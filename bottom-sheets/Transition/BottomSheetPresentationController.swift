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

    private var state: State = .compressed

    override var presentationStyle: UIModalPresentationStyle {
        return .overCurrentContext
    }

    override var shouldPresentInFullscreen: Bool {
        return false
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView, let presentedView = presentedView else { return }

        // Setup presentation
        containerView.addSubview(presentedView)
        presentedView.translatesAutoresizingMaskIntoConstraints = false

        let constraint = presentedView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: containerView.bounds.height)
        NSLayoutConstraint.activate([
            constraint,
            presentedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            presentedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            presentedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        // Setup interaction controller
        interactionController?.setup(with: constraint)

        self.constraint = constraint
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        print("Begin presentation")
        interactionController = nil
        print("Container gestures:", containerView?.gestureRecognizers)
    }
}

extension BottomSheetPresentationController: BottomSheetGestureControllerDelegate {
    func gestureDidBegin() -> CGFloat {
        return 0
    }

    func gestureDidChange(position: CGFloat) {}

    func gestureDidEnd(with state: BottomSheetPresentationController.State, andTargetPosition position: CGFloat) {}

    func currentPresentationState(for gestureController: BottomSheetGestureController) -> BottomSheetPresentationController.State {
        return state
    }
}

/*class BottomSheetPresentationController: UIPresentationController {

    let animator = SpringAnimator(dampingRatio: 0.78, frequencyResponse: 0.5)
    var constraint: NSLayoutConstraint?
    var panGesture: UIPanGestureRecognizer?

    weak var bottomSheetDelegate: BottomSheetPresentationDelegate?

    private var initialVelocity: CGPoint = .zero
    private var initialConstant = 0 as CGFloat

    private var threshold = 78 as CGFloat
    private var minValue = 44 as CGFloat

    private var currentState: BottomSheet.State = .compressed
    private var trackingState: BottomSheet.State = .compressed

    override var presentationStyle: UIModalPresentationStyle {
        return .overCurrentContext
    }

    override var shouldPresentInFullscreen: Bool {
        return false
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView, let presentedView = presentedView else { return }
        containerView.addSubview(presentedView)
        presentedView.translatesAutoresizingMaskIntoConstraints = false

        constraint = presentedView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: containerView.frame.height)
        NSLayoutConstraint.activate([
            constraint!,
            presentedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            presentedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            presentedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])

        containerView.layoutIfNeeded()
        animator.constraint = constraint

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        presentedView.addGestureRecognizer(panGesture!)
    }

    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        guard let containerView = containerView, let constraint = constraint else { return }
        let translation = gesture.translation(in: containerView)

        switch gesture.state {
        case .began:
            animator.pauseAnimation()
            initialConstant = constraint.constant

        case .changed:
            trackingState = nextState(forTransition: translation, withCurrent: currentState, usingThreshold: threshold)
            let constant = initialConstant + translation.y
            if constant < minValue {
                constraint.constant = minValue
                bottomSheetDelegate?.bottomSheetDidFullyExpand()
            }
            else { constraint.constant = constant }

        case .ended:
            initialVelocity = gesture.velocity(in: containerView)

            if trackingState != currentState {
                currentState = trackingState
                bottomSheetDelegate?.bottomSheetDidChangeState(currentState)
            }

            let target = constant(for: trackingState)

            if trackingState == .dismissed {
                presentedViewController.dismiss(animated: true)
            }

            animator.targetPosition = target
            animator.initialVelocity = initialVelocity.y
            switch animator.state {
            case .paused:
                animator.continueAnimation()
            default:
                animator.startAnimation()
            }

        default:
            return
        }
    }
}

extension BottomSheetPresentationController: UIViewControllerInteractiveTransitioning {

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        animator.targetPosition = constant(for: currentState)
        animator.initialVelocity = initialVelocity.y
        animator.completion = { didComplete in
            transitionContext.completeTransition(didComplete)
        }
        animator.startAnimation()
    }
}

private extension BottomSheetPresentationController {

    func nextState(forTransition transition: CGPoint, withCurrent current: BottomSheet.State, usingThreshold threshold: CGFloat) -> BottomSheet.State {
        switch current {
        case .compressed:
            if transition.y < -threshold { return .expanded }
            else if transition.y > threshold { return .dismissed }
        case .expanded:
            if transition.y > threshold { return .compressed }
        case .dismissed:
            if transition.y < -threshold { return .compressed }
        }
        return current
    }

    func constant(for state: BottomSheet.State) -> CGFloat {
        guard let containerView = containerView else { return 0 }
        switch state {
        case .compressed:
            return containerView.frame.height / 2
        case .expanded:
            return minValue
        case .dismissed:
            return containerView.frame.height
        }
    }
}

extension BottomSheetPresentationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        return
    }
}*/
