//
//  BottomSheet.swift
//  bottom-sheets
//
//  Created by Granheim Brustad , Henrik on 09/10/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

class BottomSheet: UIViewController {

    let notch: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let transitionDelegate = BottomSheetTransitioningDelegate()

    var rootViewController: UIViewController

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = transitionDelegate
        modalPresentationStyle = .custom
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        view.addSubview(notch)

        addChild(rootViewController)
        view.insertSubview(rootViewController.view, belowSubview: notch)
        rootViewController.didMove(toParent: self)
        rootViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            notch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notch.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            notch.heightAnchor.constraint(equalToConstant: 4),
            notch.widthAnchor.constraint(equalToConstant: 25),

            rootViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            rootViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

