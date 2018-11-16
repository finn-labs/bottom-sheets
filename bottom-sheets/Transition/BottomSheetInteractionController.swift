//
//  BottomSheetInteractionController.swift
//  bottom-sheets
//
//  Created by Granheim Brustad , Henrik on 14/11/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

/**
 This class is controlling the animation of the transition using the animator object

 This object should be delegate of the gesture controller during the transition in order to controll the constraint.
 The presentation controller owns the gesture controller and have to set the delegate.
**/
class BottomSheetInteractionController: NSObject, UIViewControllerInteractiveTransitioning {

    var animator: BottomSheetAnimationController?
    var initialTransitionVelocity = 0 as CGFloat

    var presentationState: BottomSheetPresentationController.State = .compressed
    var transitionState: BottomSheetTransitioningDelegate.State = .present

    private var constraint: NSLayoutConstraint?
    private var transitionContext: UIViewControllerContextTransitioning?

    func setup(with constraint: NSLayoutConstraint?) {
        self.constraint = constraint
        animator?.setup(with: constraint)
    }

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        // Keep track of context for any future transition related actions
        self.transitionContext = transitionContext
        // Start transition animation
        switch transitionState {
        case .present:
            animator?.targetPosition = transitionContext.containerView.bounds.height / 2
        case .dismiss:
            animator?.targetPosition = transitionContext.containerView.bounds.height
        }
        animator?.initialVelocity = initialTransitionVelocity
        animator?.animateTransition(using: transitionContext)
    }
}

extension BottomSheetInteractionController: BottomSheetGestureControllerDelegate {
    func gestureDidBegin() -> CGFloat {
        // interrupt the transition
        animator?.pauseTransition()
        return constraint?.constant ?? 0
    }

    func gestureDidChange(position: CGFloat) {
        // Update constraint based on gesture
        constraint?.constant = position
    }

    func gestureDidEnd(with state: BottomSheetPresentationController.State, targetPosition position: CGFloat, andVelocity velocity: CGFloat) {
        // Can only interact with the presented transition for now
        guard transitionState == .present, let transitionContext = transitionContext else { return }
        self.presentationState = state
        animator?.initialVelocity = velocity
        animator?.targetPosition = position
        switch state {
        case .dismissed: animator?.cancelTransition(using: transitionContext)
        default: animator?.continueTransition()
        }
    }

    func currentPresentationState(for gestureController: BottomSheetGestureController) -> BottomSheetPresentationController.State {
        return presentationState
    }
}
