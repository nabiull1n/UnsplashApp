//
//  LikedViewTableViewCell.swift
//  UnsplashApp
//
//  Created by Денис Набиуллин on 30.03.2023.
//

import UIKit
import SDWebImage

final class LikedViewTableViewCell: UITableViewCell {
    static let identifer = "SecondViewTableViewCell"
    private let photosImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    private let labelName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(photosImageView)
        contentView.addSubview(labelName)
        backgroundColor = .clear
        selectionStyle = .none
        setConstraints()
    }
    func dataAssignment (photo: String, name: String) {
        labelName.text = name
        guard let url = URL(string: "\(photo)") else { return }
        photosImageView.sd_setImage(with: url, completed: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LikedViewTableViewCell {
    func setConstraints() {
        NSLayoutConstraint.activate([
            photosImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            photosImageView.heightAnchor.constraint(equalToConstant: 50),
            photosImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            photosImageView.widthAnchor.constraint(equalToConstant: 50),
            labelName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            labelName.leadingAnchor.constraint(equalTo: photosImageView.trailingAnchor, constant: 10),
            labelName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
            labelName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
}
