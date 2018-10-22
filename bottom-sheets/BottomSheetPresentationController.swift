//
//  BottomSheetPresentationController.swift
//  bottom-sheets
//
//  Created by Granheim Brustad , Henrik on 16/10/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

class BottomSheetPresentationController: UIPresentationController {

    var animator: UIViewPropertyAnimator?
    var constraint: NSLayoutConstraint?
    var panGesture: UIPanGestureRecognizer?

    private let dimView = UIView(frame: .zero)
    private var initialVelocity: CGVector?
    private var initialConstant = 0 as CGFloat
    private var threshold = 64 as CGFloat
    private var minValue = 44 as CGFloat
    private var state: BottomSheet.State = .none

    override var presentationStyle: UIModalPresentationStyle {
        return .overCurrentContext
    }

    override var shouldPresentInFullscreen: Bool {
        return false
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView, let presentedView = presentedView else { return }
        containerView.backgroundColor = .red
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
        constraint?.constant = constant(for: .compressed)

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        presentedView.addGestureRecognizer(panGesture!)
    }

    override func dismissalTransitionWillBegin() {
        constraint?.constant = constant(for: .dismiss)
    }

    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        guard let bottomSheet = presentedViewController as? BottomSheet, let constraint = constraint else { return }
        let translation = gesture.translation(in: containerView)

        switch gesture.state {
        case .began:
            initialConstant = constraint.constant

        case .changed:
            state = nextState(forTransition: translation, withCurrent: bottomSheet.state, usingThreshold: threshold)
            let constant = initialConstant + translation.y
            guard constant >= minValue else { return }
            constraint.constant = constant

        case .ended:
            bottomSheet.state = state

            // Normalize gesture velocity
            let target = constant(for: state)
            let velocity = gesture.velocity(in: containerView).y / (target - constraint.constant)
            initialVelocity = CGVector(dx: 0, dy: velocity)

            if state == .dismiss {
                bottomSheet.dismiss(animated: true, completion: nil)
                return
            }

            constraint.constant = target
            animate(to: state)

        default:
            return
        }
    }
}

extension BottomSheetPresentationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animate(to: state) { position in
            let didComplete = position == .end
            transitionContext.completeTransition(didComplete)
        }
    }
}

private extension BottomSheetPresentationController {

    func animate(to state: BottomSheet.State, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        let velocity = initialVelocity ?? .zero
        animator = UIViewPropertyAnimator(duration: 0, timingParameters: UISpringTimingParameters(dampingRatio: BottomSheet.dampingRatio, frequencyResponse: BottomSheet.frequencyResponse, initialVelocity: velocity))
        animator?.addAnimations { self.containerView?.layoutIfNeeded() }
        if let completion = completion { animator?.addCompletion(completion) }
        animator?.startAnimation()
    }

    func nextState(forTransition transition: CGPoint, withCurrent current: BottomSheet.State, usingThreshold threshold: CGFloat) -> BottomSheet.State {
        switch current {
        case .compressed:
            if transition.y < -threshold { return .expanded }
            else if transition.y > threshold { return .dismiss }
            return current

        case .expanded:
            if transition.y > threshold { return .compressed }
            return current

        default:
            return current
        }
    }

    func constant(for state: BottomSheet.State) -> CGFloat {
        guard let containerView = containerView else { return 0 }
        switch state {
        case .compressed:
            return containerView.frame.height / 2
        case .expanded:
            return minValue
        case .dismiss:
            return containerView.frame.height
        default:
            return 0
        }
    }
}
