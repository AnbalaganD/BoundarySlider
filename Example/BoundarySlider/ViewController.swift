//
//  ViewController.swift
//  BoundarySlider
//
//  Created by Anbalagan D on 08/10/2024.
//  Copyright (c) 2024 Anbalagan D. All rights reserved.
//

import UIKit
import BoundarySlider

class ViewController: UIViewController {
    private var boundarySlider: BoundarySlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addDisplayLink()
    }
    
    private func setupView() {
        boundarySlider = BoundarySlider()
        boundarySlider.translatesAutoresizingMaskIntoConstraints = false
        boundarySlider.minimumValue = 0.0
        boundarySlider.maximumValue = 100.0
        boundarySlider.boundaries = [
            12, 33, 45, 60, 76, 90, 99
        ]
        view.addSubview(boundarySlider)
        
        NSLayoutConstraint.activate([
            boundarySlider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            boundarySlider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            boundarySlider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            boundarySlider.heightAnchor.constraint(equalToConstant: 4),
        ])
    }
    
    private func addDisplayLink() {
        let displayLink = CADisplayLink(target: self, selector: #selector(changeSliderValue))
        displayLink.preferredFramesPerSecond = 5
        displayLink.add(to: .current, forMode: .default)
    }
    
    @objc private func changeSliderValue() {
        boundarySlider.value += 1
        boundarySlider.bufferValue += 1.3
    }
}
