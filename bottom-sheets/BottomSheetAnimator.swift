//
//  BottomSheetAnimator.swift
//  bottom-sheets
//
//  Created by Granheim Brustad , Henrik on 10/10/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

class BottomSheetAnimator {

    // MARK: - Static Properties

    static let timingParameters = UISpringTimingParameters(dampingRatio: 1.0, initialVelocity: CGVector(dx: 0, dy: 10))
    static let animationDuration = 0.6

    // MARK: - Public Properties

    lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
    // This is the constraints which is animated, should be anchored to the bottom sheets top anchor
    var constraint: NSLayoutConstraint?
    // The bottom sheet which is animated
    weak var bottomSheet: BottomSheet?

    // MARK: - Private Properties

    private var animator: UIViewPropertyAnimator!
    private var initialConstant: CGFloat = 0
    private var threshold: CGFloat = 64
    private var nextState: BottomSheet.State = .none
}

private extension BottomSheetAnimator {
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        guard let state = bottomSheet?.state, let containerView = bottomSheet?.view.superview, let constraint = constraint else { return }
        let translation = gesture.translation(in: bottomSheet?.view)

        switch gesture.state {
        case .began:
            initialConstant = constraint.constant

        case .ended:
            guard nextState != .dismiss else {
                bottomSheet?.dismiss(animated: true, completion: nil)
                return
            }
            
            constraint.constant = targetConstant(for: nextState, in: containerView)
            bottomSheet?.state = nextState

            animator = UIViewPropertyAnimator(duration: BottomSheetAnimator.animationDuration, timingParameters: BottomSheetAnimator.timingParameters)
            animator.addAnimations { containerView.layoutIfNeeded() }
            animator.startAnimation()

        case .changed:
            nextState = nextState(forTranslation: translation, withCurrent: state)
            constraint.constant = initialConstant + translation.y

        default:
            break
        }
    }

    func targetConstant(for state: BottomSheet.State, in view: UIView) -> CGFloat {
        switch state {
        case .compressed:
            return view.frame.height / 2
        case .expanded:
            return 44
        case .dismiss:
            return view.frame.height
        default:
            return 0
        }
    }

    func nextState(forTranslation translate: CGPoint, withCurrent current: BottomSheet.State) -> BottomSheet.State {
        switch current {
        case .compressed:
            if translate.y < -threshold { return .expanded }
            else if translate.y > threshold { return .dismiss }
            return current

        case .expanded:
            if translate.y > threshold { return .compressed }
            return current

        default:
            return current
        }
    }
}
