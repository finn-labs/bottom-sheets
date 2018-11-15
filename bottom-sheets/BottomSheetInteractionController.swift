//
//  BottomSheetInteractionController.swift
//  bottom-sheets
//
//  Created by Granheim Brustad , Henrik on 14/11/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

protocol BottomSheetInteractionDelegate {
    
}

class BottomSheetInteractionController: NSObject, UIViewControllerInteractiveTransitioning {

    var animator: BottomSheetAnimationController?
    var panGesture: UIPanGestureRecognizer?

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        print("Start")
    }
}
