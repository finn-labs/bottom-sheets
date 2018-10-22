//
//  ViewController.swift
//  bottom-sheets
//
//  Created by Granheim Brustad , Henrik on 09/10/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Present", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hue: 0.3, saturation: 0.3, brightness: 0.6, alpha: 1.0)
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let transitionDelegate = BottomSheetTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -64),
        ])
    }

    @objc func buttonPressed(sender: UIButton) {
        let bottomSheet = BottomSheet()
        bottomSheet.transitioningDelegate = transitionDelegate
        bottomSheet.modalPresentationStyle = .custom
        present(bottomSheet, animated: true)
    }
}

