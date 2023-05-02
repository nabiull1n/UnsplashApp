//
//  HomeViewCollectionViewCell.swift
//  UnsplashApp
//
//  Created by Денис Набиуллин on 27.03.2023.
//

import UIKit
import SDWebImage

final class HomeViewCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeViewCollectionViewCell"
    private var photosImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photosImageView)
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func dataAssignment(with image: String){
        guard let url = URL(string: "\(image)") else { return }
        DispatchQueue.main.async {
            self.photosImageView.sd_imageIndicator = .none
            self.photosImageView.sd_setImage(with: url, completed: nil)
        }
    }
}
private extension HomeViewCollectionViewCell {
    func setConstraints() {
        NSLayoutConstraint.activate([
            photosImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photosImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            photosImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            photosImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
}
