//
//  BottomSheetInteractionController.swift
//  bottom-sheets
//
//  Created by Granheim Brustad , Henrik on 14/11/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

/**
 This object is controlling the animation of the transition using the animator object

 This object should be the delegate of a gesture controller during the transition in order to interact with the transition.
 The presentation controller owns the gesture controller and have to set the delegate.
 The constraint should also be provided by the presentation controller
**/
class BottomSheetInteractionController: NSObject, UIViewControllerInteractiveTransitioning {

    let animationController: BottomSheetAnimationController
    var initialTransitionVelocity = 0 as CGFloat
    var targetTransitionPosition = 0 as CGFloat

    var presentationState: BottomSheetPresentationController.State = .compressed

    private var constraint: NSLayoutConstraint?
    private var transitionContext: UIViewControllerContextTransitioning?

    init(animationController: BottomSheetAnimationController) {
        self.animationController = animationController
    }

    func setup(with constraint: NSLayoutConstraint?) {
        self.constraint = constraint
        animationController.setup(with: constraint)
    }

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        // Keep track of context for any future transition related actions
        self.transitionContext = transitionContext
        // Start transition animation
        animationController.targetPosition = targetTransitionPosition
        animationController.initialVelocity = initialTransitionVelocity
        animationController.animateTransition(using: transitionContext)
    }
}

// The interaction is only used during the presentation transition
extension BottomSheetInteractionController: BottomSheetGestureControllerDelegate {
    func gestureDidBegin() -> CGFloat {
        // interrupt the transition
        animationController.pauseTransition()
        return constraint?.constant ?? 0
    }

    func gestureDidChange(position: CGFloat) {
        // Update constraint based on gesture
        constraint?.constant = position
    }

    func gestureDidEnd(with state: BottomSheetPresentationController.State, targetPosition position: CGFloat, andVelocity velocity: CGFloat) {
        guard let transitionContext = transitionContext else { return }
        self.presentationState = state
        animationController.initialVelocity = velocity
        animationController.targetPosition = position
        switch state {
        case .dismissed: animationController.cancelTransition(using: transitionContext)
        default: animationController.continueTransition()
        }
    }

    func currentPresentationState(for gestureController: BottomSheetGestureController) -> BottomSheetPresentationController.State {
        return presentationState
    }
}
