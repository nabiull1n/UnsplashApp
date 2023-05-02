//
//  HomeViewController.swift
//  UnsplashApp
//
//  Created by Денис Набиуллин on 27.03.2023.
//

import UIKit
import Alamofire
import SDWebImage

protocol informationFromDetailedVcDelegate: AnyObject {
    func assigningDataDetailedVC (homeScreenData: HomeScreenData)
}
final class HomeViewController: UIViewController {
    
    weak var delegate: informationFromDetailedVcDelegate?
    private var homeArray : [UnsplashPhoto] = []
    private let countItem: CGFloat = 2
    private let sectionInsert = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private let searchController = UISearchController()

    private let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(HomeViewCollectionViewCell.self,
                            forCellWithReuseIdentifier: HomeViewCollectionViewCell.identifier)
        return collection
    }()
    private let homeRefresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(hanleHomeRefresh), for: .valueChanged)
        return refresh
    }()
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        homeScreenRequest()
    }
    @objc func hanleHomeRefresh(){
        DispatchQueue.main.async {
            UnsplashAPI.loadRandomPhotos(count: 5) { [weak self] result in
                guard let self = self else { return }
                self.homeArray.insert(result, at: 0)
                self.photosCollectionView.reloadData()
            }
        }
        self.homeRefresh.endRefreshing()
    }
    @objc func searchTapped(){
        present(searchController, animated: true, completion: nil)
        searchController.searchBar.becomeFirstResponder()
        navigationItem.rightBarButtonItem = nil
        searchController.searchBar.isHidden = false
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.delegate = self
    }
    private func setupViews() {
        photosCollectionView.addSubview(homeRefresh)
        view.backgroundColor = .white
        title = "Home"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(searchTapped))
        view.addSubview(photosCollectionView)
        setConstraints()
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
    }
    private func homeScreenRequest() {
        UnsplashAPI.loadRandomPhotos(count: 10) { [weak self] result in
            guard let self = self else { return }
            self.homeArray.append(result)
            self.photosCollectionView.reloadData()
        }
    }
}
// MARK: UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.homeArray.removeAll()
        SearchRequest.searchPhotos(name: text) { [weak self] result in
            self?.homeArray.append(result!)
            self?.photosCollectionView.reloadData()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(searchTapped))
    }
}
// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewCollectionViewCell.identifier,
                                                            for: indexPath) as? HomeViewCollectionViewCell else { return UICollectionViewCell() }
        guard let image = homeArray[indexPath.item].regular else { return UICollectionViewCell() }
        cell.dataAssignment(with: image)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        homeArray.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let url = homeArray[indexPath.item].regular,
              let data = homeArray[indexPath.item].createdAt,
              let author = homeArray[indexPath.item].name,
              let downloads = homeArray[indexPath.item].downloads,
              let id = homeArray[indexPath.item].id else { return }
        let delegateVC = DetailedScreenViewController()
        delegate = delegateVC
        delegate?.assigningDataDetailedVC(homeScreenData: HomeScreenData(id: id,
                                                             image: url,
                                                             author: author,
                                                             data: data,
                                                             downloads: downloads,
                                                             array: homeArray[indexPath.row]))
        navigationController?.pushViewController(delegateVC, animated: true)
    }
}
// MARK: UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = homeArray[indexPath.row]
        let space = sectionInsert.left * (countItem + 1)
        let itemsWidth = view.frame.width - space
        let widthPerItem = itemsWidth / countItem
        let height = CGFloat(photo.height ?? 100) * widthPerItem / CGFloat(photo.width ?? 100)
        return CGSize(width: widthPerItem, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInsert.left
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInsert
    }
}
// MARK: setConstraints
private extension HomeViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
}
