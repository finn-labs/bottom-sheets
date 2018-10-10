//
//  BottomSheet.swift
//  bottom-sheets
//
//  Created by Granheim Brustad , Henrik on 09/10/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

extension BottomSheet {

    enum State {
        case expanded
        case compressed
        case dismiss
        case none
    }
}

class BottomSheet: UIViewController {

    let notch: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var state = BottomSheet.State.compressed
    var animator: BottomSheetAnimator

    init(with animator: BottomSheetAnimator) {
        self.animator = animator
        super.init(nibName: nil, bundle: nil)
        self.animator.bottomSheet = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        view.addSubview(notch)

        NSLayoutConstraint.activate([
            notch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notch.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            notch.heightAnchor.constraint(equalToConstant: 4),
            notch.widthAnchor.constraint(equalToConstant: 25)
        ])

        view.addGestureRecognizer(animator.panGesture)
    }
}
