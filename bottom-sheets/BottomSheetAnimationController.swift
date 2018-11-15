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

    private let animator = SpringAnimator(dampingRatio: 0.78, frequencyResponse: 0.5)

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        print("Animate transition")
    }
}
