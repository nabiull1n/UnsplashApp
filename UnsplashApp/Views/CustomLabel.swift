//
//  CustomLabel.swift
//  UnsplashApp
//
//  Created by Денис Набиуллин on 29.04.2023.
//

import UIKit

final class CustomLabel: UILabel{
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .black
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
