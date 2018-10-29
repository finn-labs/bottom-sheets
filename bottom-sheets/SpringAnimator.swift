//
//  SpringAnimator.swift
//  spring-physics
//
//  Created by Granheim Brustad , Henrik on 27/10/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

class SpringAnimator: NSObject {

    // Spring properties
    let damping: CGFloat
    let stiffness: CGFloat

    // View properties
    private var velocity = 0.0 as CGFloat
    private var position = 0.0 as CGFloat
    var initialVelocity: CGFloat = 0 {
        didSet { velocity = -initialVelocity }
    }

    // Animation properties
    var isAnimating = false
    var targetPosition = 0 as CGFloat
    var constraint: NSLayoutConstraint?

    var completion: ((Bool) -> Void)?

    private let scale = 1 / UIScreen.main.scale
    private var displayLink: CADisplayLink?

    init(dampingRatio: CGFloat, frequencyResponse: CGFloat) {
        self.stiffness = pow(2 * .pi / frequencyResponse, 2)
        self.damping = 2 * dampingRatio * sqrt(stiffness)
    }

    func startAnimation() {
        guard let constraint = constraint else { return }
        position = targetPosition - constraint.constant

        guard position != 0, displayLink == nil else { return }
        displayLink = CADisplayLink(target: self, selector: #selector(step(displayLink:)))
        displayLink?.add(to: .current, forMode: .default)
        isAnimating = true
    }

    func stopAnimation() {
        stopAnimation(didComplete: false)
    }

    @objc func step(displayLink: CADisplayLink) {
        let acceleration = -velocity * damping - position * stiffness
        velocity += acceleration * CGFloat(displayLink.duration)
        position += velocity * CGFloat(displayLink.duration)
        constraint?.constant = targetPosition - position

        if abs(position) < scale, abs(velocity) < scale {
            stopAnimation(didComplete: true)
        }
    }
}

private extension SpringAnimator {
    func stopAnimation(didComplete: Bool) {
        if didComplete { constraint?.constant = targetPosition }
        displayLink?.invalidate()
        displayLink = nil
        completion?(true)
        completion = nil
        isAnimating = false
    }
}
