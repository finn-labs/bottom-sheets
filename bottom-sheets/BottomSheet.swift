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

    static let dampingRatio = 0.85 as CGFloat
    static let frequencyResponse = 0.45 as CGFloat

    let notch: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var state = BottomSheet.State.compressed

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)

        view.addSubview(notch)

        NSLayoutConstraint.activate([
            notch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notch.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            notch.heightAnchor.constraint(equalToConstant: 4),
            notch.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
}
