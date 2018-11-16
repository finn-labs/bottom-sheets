//
//  BottomSheetTransition.swift
//  bottom-sheets
//
//  Created by Granheim Brustad , Henrik on 09/10/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

extension BottomSheetTransitioningDelegate {
    enum State {
        case present, dismiss
    }
}

class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    var presentationController: BottomSheetPresentationController?

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        presentationController = BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetAnimationController()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetAnimationController()
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? BottomSheetAnimationController else { return nil }
        let interactionController = BottomSheetInteractionController()
        interactionController.animator = animator
        presentationController?.interactionController = interactionController
        return interactionController
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? BottomSheetAnimationController else { return nil }
        let interactionController = BottomSheetInteractionController()
        interactionController.animator = animator
        presentationController?.interactionController = interactionController
        return interactionController
    }
}
