//
//  BottomSheetPresentationController.swift
//  bottom-sheets
//
//  Created by Granheim Brustad , Henrik on 16/10/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

extension BottomSheetPresentationController {
    enum State {
        case expanded
        case compressed
        case dismissed
    }
}

class BottomSheetPresentationController: UIPresentationController {
    
    var interactionController: BottomSheetInteractionController?

    private var constraint: NSLayoutConstraint?
    private var gestureController: BottomSheetGestureController?

    private var presentationState: State = .compressed
    private var springAnimator = SpringAnimator(dampingRatio: 0.78, frequencyResponse: 0.5)

    override var presentationStyle: UIModalPresentationStyle {
        return .overCurrentContext
    }

    override var shouldPresentInFullscreen: Bool {
        return false
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView, let presentedView = presentedView else { return }
        // Setup views
        containerView.addSubview(presentedView)
        presentedView.translatesAutoresizingMaskIntoConstraints = false
        constraint = presentedView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: containerView.bounds.height)
        NSLayoutConstraint.activate([
            constraint!,
            presentedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            presentedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            presentedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        // Setup gesture with interactive transition as delegate
        gestureController = BottomSheetGestureController(presentedView: presentedView, containerView: containerView)
        gestureController?.delegate = interactionController
        // Setup interactive transition
        interactionController?.setup(with: constraint)
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        guard completed else { return }
        setupPresentation()
    }

    override func dismissalTransitionWillBegin() {
        // Clean up animator and gesture
        springAnimator.stopAnimation()
        // Setup interaction controller for dismissal
        interactionController?.setup(with: constraint)
        interactionController?.presentationState = presentationState
        interactionController?.initialTransitionVelocity = gestureController?.velocity ?? 0
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        guard !completed else { return }
        setupPresentation()
    }
}

private extension BottomSheetPresentationController {
    func setupPresentation() {
        // Setup gesture and animation for presentation
        presentationState = interactionController?.presentationState ?? .compressed
        gestureController?.delegate = self
        springAnimator.constraint = constraint
    }
}

extension BottomSheetPresentationController: BottomSheetGestureControllerDelegate {
    func gestureDidBegin() -> CGFloat {
        springAnimator.pauseAnimation()
        return constraint?.constant ?? 0
    }

    func gestureDidChange(position: CGFloat) {
        constraint?.constant = position
    }

    func gestureDidEnd(with state: BottomSheetPresentationController.State, targetPosition position: CGFloat, andVelocity velocity: CGFloat) {
        self.presentationState = state
        switch state {
        case .dismissed:
            presentedViewController.dismiss(animated: true)
        default:
            springAnimator.targetPosition = position
            springAnimator.initialVelocity = velocity
            springAnimator.startAnimation()
        }
    }

    func currentPresentationState(for gestureController: BottomSheetGestureController) -> BottomSheetPresentationController.State {
        return presentationState
    }
}
