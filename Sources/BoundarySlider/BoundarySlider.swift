//
//  BoundarySlider.swift
//  MusicPlayer
//
//  Created by Anbalagan on 09/08/24.
//

import UIKit

/// This view will show the boundary with in slide.
/// If slide reach that boundary will invoke callback to gitve option to execute custom logic
public final class BoundarySlider: UIControl {
    private var trackLayer: CALayer!
    private var fillTrackerLayer: CALayer!
    private var bufferLayer: CALayer!
    private var boundaryLayerDictionary = [Float: CALayer]()
    private var thumbInitialXPosition: Float = 0.0

    public var trackColor: UIColor = .gray
    public var fillTrackColor: UIColor = .red
    public var bufferTrackColor: UIColor = .init(white: 1.0, alpha: 0.6)
    public var boundaryColor: UIColor = .systemYellow

    public var minimumValue: Float = 0.0
    public var maximumValue: Float = 1.0

    private var _value: Float = 0.0
    public var value: Float {
        get { _value }
        set {
            _value = max(minimumValue, min(newValue, maximumValue))
            adjustFillTrackerLayerPosition()
        }
    }

    private var _bufferValue: Float = 0.0
    public var bufferValue: Float {
        get { _bufferValue }
        set {
            _bufferValue = max(minimumValue, min(newValue, maximumValue))
            adjustBufferLayerPosition()
        }
    }

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

/*
 ***** Feature ******
 1. Multiple boundary
 2. Buffer view like youtube video buffer
 3. Seek support
 4. Customizable thumb image (Not yet)
 5. Haptic support if reach boundary (Not yet)
 6. Min, Max value label (Not yet)
 7. Min, Max value label position like top, middle, bottom (Not yet)
 */
