//
//  BottomSheetAnimator.swift
//  bottom-sheets
//
//  Created by Granheim Brustad , Henrik on 14/11/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

extension BottomSheetAnimationController {
    enum State {
        case present, dismiss
    }
}

class BottomSheetAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    var state: State = .present
    var initialVelocity = 0 as CGFloat

    private let animator = SpringAnimator(dampingRatio: 0.78, frequencyResponse: 0.5)

    func setup(with constraint: NSLayoutConstraint?) {
        animator.constraint = constraint
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animator.targetPosition = transitionContext.containerView.frame.height / 2
        animator.completion = { didComplete in
            transitionContext.completeTransition(didComplete)
        }
        animator.initialVelocity = initialVelocity
        animator.startAnimation()
    }

    func cancelTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard animator.state == .paused else { return }
        animator.targetPosition = transitionContext.containerView.frame.height
        animator.completion = { _ in
            transitionContext.completeTransition(false)
        }
        animator.initialVelocity = initialVelocity
        animator.continueAnimation()
    }

    func pauseAnimation() {
        animator.pauseAnimation()
    }

    func continueAnimation(toTargetPosition position: CGFloat) {
        animator.targetPosition = position
        animator.continueAnimation()
    }
}
