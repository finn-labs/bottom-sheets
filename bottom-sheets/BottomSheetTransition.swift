//
//  BottomSheetTransition.swift
//  bottom-sheets
//
//  Created by Granheim Brustad , Henrik on 09/10/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit


class BottomSheetTransition: NSObject, UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetPresentationAnimation(duration: BottomSheetAnimator.animationDuration)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetDismissAnimation(duration: BottomSheetAnimator.animationDuration)
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }

}

class BottomSheetPresentationController: UIPresentationController {

    private let dimView = UIView(frame: .zero)

    override var shouldPresentInFullscreen: Bool {
        return false
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView, let presentedView = presentedView else { return }
        dimView.frame = containerView.bounds
        dimView.backgroundColor = UIColor(white: 0, alpha: 0)
        containerView.insertSubview(dimView, belowSubview: presentedView)

        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            self.dimView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        }
        animator.startAnimation()
    }

    override func dismissalTransitionWillBegin() {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            self.dimView.backgroundColor = UIColor(white: 0, alpha: 0)
        }
        animator.startAnimation()
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        dimView.isHidden = true
    }

}

class BottomSheetPresentationAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    var animator: UIViewPropertyAnimator!
    var duration: Double

    init(duration: Double) {
        self.duration = duration
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let _ = transitionContext.viewController(forKey: .from), let bottomSheet = transitionContext.viewController(forKey: .to) as? BottomSheet else { return }
        let containerView = transitionContext.containerView

        containerView.addSubview(bottomSheet.view)
        bottomSheet.view.frame = CGRect(x: 0, y: containerView.frame.maxY, width: containerView.frame.width, height: 0)
        bottomSheet.view.layoutIfNeeded()
        bottomSheet.view.translatesAutoresizingMaskIntoConstraints = false

        let topConstraint = bottomSheet.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: containerView.frame.height / 2)
        bottomSheet.animator.constraint = topConstraint

        NSLayoutConstraint.activate([
            topConstraint,
            bottomSheet.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomSheet.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomSheet.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        animator = UIViewPropertyAnimator(duration: duration, timingParameters: BottomSheetAnimator.timingParameters)
        animator.addAnimations { containerView.layoutIfNeeded() }
        animator.addCompletion { position in
            let didComplete = position == .end
            transitionContext.completeTransition(didComplete)
        }
        animator.startAnimation()
    }

    func animationEnded(_ transitionCompleted: Bool) {
        print("Transition is complete")
    }
}

class BottomSheetDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    var animator: UIViewPropertyAnimator!
    var duration: Double

    init(duration: Double) {
        self.duration = duration
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let bottomSheet = transitionContext.viewController(forKey: .from) as? BottomSheet, let _ = transitionContext.viewController(forKey: .to)  else { return }
        let containerView = transitionContext.containerView

        bottomSheet.animator.constraint?.constant = containerView.frame.height

        animator = UIViewPropertyAnimator(duration: duration, timingParameters: BottomSheetAnimator.timingParameters)
        animator.addAnimations { containerView.layoutIfNeeded() }
        animator.addCompletion { position in
            let didComplete = position == .end
            transitionContext.completeTransition(didComplete)
        }
        animator.startAnimation()
    }

    func animationEnded(_ transitionCompleted: Bool) {
        print("Transition is complete")
    }
}
