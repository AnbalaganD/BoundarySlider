//
//  BoundarySlider.swift
//  BoundarySlider
//
//  Created by Anbalagan on 09/08/24.
//

import UIKit

/// A horizontal slider control that supports buffered progress and visual boundary markers.
///
/// `BoundarySlider` renders three tracks:
/// - a base track (`trackColor`),
/// - an optional buffer track (`bufferTrackColor`) indicating preloaded progress, and
/// - a filled track (`fillTrackColor`) representing the current `value`.
///
/// You can also provide `boundaries`, which are value positions along the track where
/// vertical markers are drawn using `boundaryColor`.
///
/// Values are expressed in the closed range [`minimumValue`, `maximumValue`]. Updating
/// `value`, `bufferValue`, or `boundaries` updates the corresponding layers immediately.
public final class BoundarySlider: UIControl {
    private var trackLayer: CALayer!
    private var fillTrackerLayer: CALayer!
    private var bufferLayer: CALayer!
    private var boundaryLayerDictionary = [Float: CALayer]()
    private var thumbInitialXPosition: Float = 0.0
    private var _value: Float = 0.0
    private var _bufferValue: Float = 0.0

    /// The base track color. Defaults to `.gray`.
    /// Changing this does not retroactively update existing layer colors; set before layout if possible.
    public var trackColor: UIColor = .gray

    /// The filled progress track color. Defaults to `.red`.
    public var fillTrackColor: UIColor = .red

    /// The buffer track color used to indicate preloaded progress. Defaults to a semi-opaque white.
    public var bufferTrackColor: UIColor = .init(white: 1.0, alpha: 0.6)

    /// The color used to draw boundary markers. Defaults to `.systemYellow`.
    public var boundaryColor: UIColor = .systemYellow

    /// The minimum slider value. Defaults to `0.0`.
    public var minimumValue: Float = 0.0

    /// The maximum slider value. Defaults to `1.0`.
    public var maximumValue: Float = 1.0

    /// The current value represented by the filled track.
    ///
    /// - Note: Setting this value clamps it to [`minimumValue`, `maximumValue`] and updates the fill layer.
    public var value: Float {
        get { _value }
        set {
            _value = max(minimumValue, min(newValue, maximumValue))
            adjustFillTrackerLayerPosition()
        }
    }

    /// The current buffer value represented by the buffer track.
    ///
    /// - Note: Setting this value clamps it to [`minimumValue`, `maximumValue`] and updates the buffer layer.
    public var bufferValue: Float {
        get { _bufferValue }
        set {
            _bufferValue = max(minimumValue, min(newValue, maximumValue))
            adjustBufferLayerPosition()
        }
    }

    /// Discrete positions along the track at which to draw boundary markers.
    ///
    /// Values outside [`minimumValue`, `maximumValue`] are ignored during layout.
    /// Updating this array recreates boundary layers and refreshes their positions.
    public var boundaries: [Float] = [] {
        didSet {
            addBoundaryLayer()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
        setupBufferLayer()
        addBoundaryLayer()
    }

    /// Creates a slider from an Interface Builder archive or storyboard.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }

    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        updateBasicPropertyOfLayer()
        adjustBufferLayerPosition()
        adjustBoundaryLayerPosition()
        setupDragGesture()
    }

    private func setupDragGesture() {
        let gestureRecognize = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        addGestureRecognizer(gestureRecognize)
    }

    @objc private func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let translationX = gesture.translation(in: self).x
        switch gesture.state {
        case .possible: break
        case .began:
            thumbInitialXPosition = value
        case .changed:
            let offsetX = CGFloat(thumbInitialXPosition) + translationX
            value = Float(max(0, min(offsetX, bounds.maxX)))
        case .ended: break
        case .cancelled: break
        case .failed: break
        case .recognized: break
        @unknown default: break
        }
    }

    private func updateBasicPropertyOfLayer() {
        trackLayer?.frame = bounds
        trackLayer?.cornerRadius = bounds.height / 2
        fillTrackerLayer?.cornerRadius = bounds.height / 2
        bufferLayer?.cornerRadius = bounds.height / 2
    }

    private func adjustFillTrackerLayerPosition() {
        let width = (bounds.width / CGFloat(maximumValue)) * CGFloat(value)
        let fillTrackerFrame = CGRect(
            x: bounds.minX,
            y: bounds.minY,
            width: max(0, min(width, bounds.width)),
            height: bounds.height
        )
        fillTrackerLayer?.frame = fillTrackerFrame
    }

    private func adjustBufferLayerPosition() {
        let width = (bounds.width / CGFloat(maximumValue)) * CGFloat(bufferValue)
        let bufferLayerFrame = CGRect(
            x: bounds.minX,
            y: bounds.minY,
            width: max(0, min(width, bounds.width)),
            height: bounds.height
        )
        bufferLayer?.frame = bufferLayerFrame
    }

    private func adjustBoundaryLayerPosition() {
        for (boundary, boundaryLayer) in boundaryLayerDictionary where minimumValue ... maximumValue ~= boundary {
            boundaryLayer.frame = CGRect(
                x: ((bounds.maxX / CGFloat(maximumValue)) * CGFloat(boundary)) - 1,
                y: bounds.minY,
                width: 2,
                height: bounds.height
            )
        }
    }

    private func setupLayer() {
        trackLayer = CALayer()
        trackLayer.backgroundColor = trackColor.withAlphaComponent(0.5).cgColor
        trackLayer.frame = bounds
        trackLayer.borderWidth = 0.5
        trackLayer.borderColor = trackColor.cgColor
        trackLayer.masksToBounds = true
        self.layer.addSublayer(trackLayer)

        fillTrackerLayer = CALayer()
        fillTrackerLayer.backgroundColor = fillTrackColor.cgColor
        fillTrackerLayer.frame = bounds
        fillTrackerLayer.zPosition = 2
        self.layer.addSublayer(fillTrackerLayer)
    }

    private func setupBufferLayer() {
        bufferLayer = CALayer()
        bufferLayer.backgroundColor = bufferTrackColor.cgColor
        bufferLayer.frame = bounds
        trackLayer.addSublayer(bufferLayer)
    }

    private func addBoundaryLayer() {
        boundaryLayerDictionary.forEach { (_, boundaryLayer: CALayer) in
            boundaryLayer.removeFromSuperlayer()
        }
        boundaryLayerDictionary.removeAll()
        for boundary in boundaries {
            let boundaryLayer = CALayer()
            boundaryLayer.backgroundColor = boundaryColor.cgColor
            boundaryLayerDictionary[boundary] = boundaryLayer
            trackLayer.addSublayer(boundaryLayer)
        }
        adjustBoundaryLayerPosition()
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !self.isHidden, self.isUserInteractionEnabled, self.alpha > 0 else { return nil }
        let expandedBounds = bounds.insetBy(dx: min(bounds.width - 10, 0), dy: min(bounds.height - 10, 0))
        return expandedBounds.contains(point) ? self : nil
    }
}
