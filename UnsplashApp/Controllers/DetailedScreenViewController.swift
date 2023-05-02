//
//  DetailedScreenViewController.swift
//  UnsplashApp
//
//  Created by Денис Набиуллин on 06.04.2023.
//

import UIKit
import RealmSwift

protocol informationFromSecondVcDelegate:AnyObject {
    func saveDidTap (addToFavorites: AddToFavorites)
}
final class DetailedScreenViewController: UIViewController {
    
    weak var delegate: informationFromSecondVcDelegate?
    private var addressImage = ""
    private var dataImage = ""
    private var idImage = ""
    private var downloadsImage = Int()
    private var isLiked = false
    private let userDefault = UserDefaults.standard
    private var detailedArray: [UnsplashPhoto] = []
    
    private let posterImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .white
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    private var authorNameLabel: CustomLabel = {
        let label = CustomLabel()
        return label
    }()
    private let dataLabel: CustomLabel = {
        let label = CustomLabel()
        return label
    }()
    private let downloadsLabel: CustomLabel = {
        let label = CustomLabel()
        return label
    }()
    private lazy var saveBarButtomItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "heart"),
                               style: .done,
                               target: self,
                               action: #selector(saveTapped))
    }()
    private lazy var deleteSaveBarButtomItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "heart.fill"),
                               style: .done,
                               target: self,
                               action: #selector(saveTapped))
    }()
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        checkingValue()
    }
    @objc func saveTapped() {
        if userDefault.string(forKey: idImage) == idImage  {
            navigationItem.rightBarButtonItem = saveBarButtomItem
            isLiked = false
            userDefault.removeObject(forKey: "\(idImage)")
            let realm = try! Realm()
            let objectId = "\(idImage)"
            let objectsToDelete = realm.objects(RealmDatabase.self).filter("id = %@", objectId)
            if !objectsToDelete.isEmpty {
                try? realm.write {
                    realm.delete(objectsToDelete)
                }
            }
        } else {
            navigationItem.rightBarButtonItem = deleteSaveBarButtomItem
            isLiked = true
            //let userDefault = UserDefaults.standard
            userDefault.set(idImage, forKey: "\(idImage)")
            guard let tabBarController = tabBarController else { return }
            guard let navController = tabBarController.viewControllers?[1] as? UINavigationController else { return }
            guard let yourViewController = navController.topViewController as? LikedViewController else { return }
            delegate = yourViewController
            delegate?.saveDidTap(addToFavorites: AddToFavorites(id: idImage,
                                                                image: addressImage,
                                                                name: authorNameLabel.text ?? "",
                                                                date: dataImage,
                                                                downloads: downloadsImage))
        }
    }
    private func checkingValue() {
        navigationController!.navigationBar.prefersLargeTitles = false
        if userDefault.string(forKey: idImage) == idImage {
            navigationItem.rightBarButtonItem = deleteSaveBarButtomItem
        } else {
            navigationItem.rightBarButtonItem = saveBarButtomItem
        }
    }
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(posterImageView)
        view.addSubview(authorNameLabel)
        view.addSubview(dataLabel)
        view.addSubview(downloadsLabel)
        setConstraints()
    }
}
// MARK: setConstraints
private extension DetailedScreenViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            posterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            posterImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            authorNameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 0),
            authorNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            authorNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            authorNameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            dataLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor),
            dataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            dataLabel.widthAnchor.constraint(equalToConstant: 150),
            dataLabel.heightAnchor.constraint(equalToConstant: 30),
            
            downloadsLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor),
            downloadsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            downloadsLabel.widthAnchor.constraint(equalToConstant: 150),
            downloadsLabel.heightAnchor.constraint(equalToConstant: 30)])
    }
}
// MARK: informationFromDetailedVcDelegate
extension DetailedScreenViewController: informationFromDetailedVcDelegate {
    func assigningDataDetailedVC(homeScreenData: HomeScreenData) {
        guard let url = URL(string: "\(homeScreenData.image)"),
              let array = homeScreenData.array else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
        addressImage = homeScreenData.image
        idImage = homeScreenData.id
        authorNameLabel.text = homeScreenData.author
        dataLabel.text = String(homeScreenData.data.prefix(10))
        dataImage = homeScreenData.data
        downloadsImage = homeScreenData.downloads
        downloadsLabel.text = "Uploaded: \(homeScreenData.downloads)"
        detailedArray.append(array)
    }
}
// MARK: informationFromTableDelegate
extension DetailedScreenViewController: informationFromTableDelegate {
    func assigningDataTableView(dataFromTable: DataFromTable) {
        guard let url = URL(string: "\(dataFromTable.image)") else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
        authorNameLabel.text = dataFromTable.name
        dataLabel.text = String(dataFromTable.date.prefix(10))
        downloadsLabel.text = "Uploaded: \(dataFromTable.downloads)"
        idImage = dataFromTable.id
    }
}
