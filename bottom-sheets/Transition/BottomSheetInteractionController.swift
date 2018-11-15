//
//  BottomSheetInteractionController.swift
//  bottom-sheets
//
//  Created by Granheim Brustad , Henrik on 14/11/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

class BottomSheetInteractionController: NSObject, UIViewControllerInteractiveTransitioning {

    var animator: BottomSheetAnimationController?

    private var constraint: NSLayoutConstraint?
    private var gestureController: BottomSheetGestureController?
    private var transitionContext: UIViewControllerContextTransitioning?

    private var state: BottomSheetPresentationController.State = .compressed

    func setup(with constraint: NSLayoutConstraint) {
        self.constraint = constraint
        animator?.setup(with: constraint)
    }

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        // Keep track of context for any future transition related actions
        self.transitionContext = transitionContext
        // Setup pan gesture
        gestureController = BottomSheetGestureController(containerView: transitionContext.containerView)
        gestureController?.delegate = self
        // Start transition animation
        animator?.animateTransition(using: transitionContext)
    }
}

extension BottomSheetInteractionController: BottomSheetGestureControllerDelegate {
    func gestureDidBegin() -> CGFloat {
        // interrupt the transition
        animator?.pauseAnimation()
        return constraint?.constant ?? 0
    }

    func gestureDidChange(position: CGFloat) {
        // Update constraint based on gesture
        constraint?.constant = position
    }

    func gestureDidEnd(with state: BottomSheetPresentationController.State, andTargetPosition position: CGFloat) {
        self.state = state
        // If user hides bottom sheet, cancel transition

        // Continue animation to either expanded or compressed state
        animator?.continueAnimation(toTargetPosition: position) // target position and velocity
    }

    func currentPresentationState(for gestureController: BottomSheetGestureController) -> BottomSheetPresentationController.State {
        return state
    }
}
