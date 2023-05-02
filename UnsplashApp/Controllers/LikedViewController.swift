//
//  LikedViewController.swift
//  UnsplashApp
//
//  Created by Денис Набиуллин on 27.03.2023.
//

import UIKit
import RealmSwift

protocol informationFromTableDelegate: AnyObject {
    func assigningDataTableView (dataFromTable: DataFromTable)
}
final class LikedViewController: UIViewController {
    
    weak var delegate: informationFromTableDelegate?
    private var dataRealm: Results<RealmDatabase>!
    private let userDefault = UserDefaults.standard
    
    private let refreshTableView: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(hanleRefreshTavleView), for: .valueChanged)
        return refresh
    }()
    
    private let favoritePhotosTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.register(LikedViewTableViewCell.self, forCellReuseIdentifier: LikedViewTableViewCell.identifer)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEditButton()
        configureRealm()
        setupViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritePhotosTableView.reloadData()
    }
    @objc func hanleRefreshTavleView(){
        favoritePhotosTableView.reloadData()
        refreshTableView.endRefreshing()
    }
    
    @objc func editButtonTapped(){
        if !dataRealm.isEmpty {
            let delete = UIBarButtonItem(title: "Delete All",
                                         style: .plain,
                                         target: self,
                                         action: #selector(deleteAllButtonTapped))
            let done = UIBarButtonItem(barButtonSystemItem: .done,
                                       target: self,
                                       action: #selector(doneTableButtonTapped))
            navigationItem.rightBarButtonItems = [done, delete]
            favoritePhotosTableView.isEditing = !favoritePhotosTableView.isEditing
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTableButtonTapped))
        }
    }
    @objc func deleteAllButtonTapped(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(doneTableButtonTapped))
        configureAlertController()
        
    }
    @objc func doneTableButtonTapped(){
        favoritePhotosTableView.isEditing = false
        let edit = UIBarButtonItem(barButtonSystemItem: .edit,
                                   target: self,
                                   action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItems = [edit]
    }
    private func setupEditButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(editButtonTapped))
    }
    private func configureAlertController() {
        let alert = UIAlertController(title: "Delete All", message: "Вы уверены?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Удалить все", style: .destructive) { action in
            let realm = try! Realm()
            try? realm.write {
                realm.deleteAll()
            }
            let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneTableButtonTapped))
            self.navigationItem.rightBarButtonItems = [done]
            if let appDomain = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: appDomain)
            }
            self.favoritePhotosTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    private func configureRealm() {
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: nil)
        let realm = try? Realm(configuration: config)
        dataRealm = realm?.objects(RealmDatabase.self)
        favoritePhotosTableView.reloadData()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "Liked"
        view.addSubview(favoritePhotosTableView)
        favoritePhotosTableView.addSubview(refreshTableView)
        favoritePhotosTableView.delegate = self
        favoritePhotosTableView.dataSource = self
        setConstraints()
    }
}
// MARK: UITableViewDelegate, UITableViewDataSource
extension LikedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataRealm.count != 0 { return dataRealm.count } else { return 0 }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let editing = dataRealm[indexPath.row]
            let objectId = editing.id
            userDefault.removeObject(forKey: "\(objectId)")
            let realm = try! Realm()
            try? realm.write {
                realm.delete(editing)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataRealm[indexPath.row]
        let delegateVC = DetailedScreenViewController()
        delegate = delegateVC
        delegate?.assigningDataTableView(dataFromTable: DataFromTable(id: item.id,
                                                                      image: item.url,
                                                                      name: item.name,
                                                                      date: item.date,
                                                                      downloads: item.downloads))
        navigationController?.pushViewController(delegateVC, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LikedViewTableViewCell.identifer,
                                                       for: indexPath) as? LikedViewTableViewCell else { return UITableViewCell() }
        let item = dataRealm[indexPath.row]
        cell.dataAssignment(photo: item.url, name: item.name)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 60 }
}
// MARK: setConstraints
private extension LikedViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            favoritePhotosTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favoritePhotosTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoritePhotosTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoritePhotosTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
}
// MARK: informationFromSecondVcDelegate
extension LikedViewController: informationFromSecondVcDelegate {
    func saveDidTap(addToFavorites: AddToFavorites) {
        let data = RealmDatabase()
        data.id = addToFavorites.id
        data.url = addToFavorites.image
        data.name = addToFavorites.name
        data.date = addToFavorites.date
        data.downloads = addToFavorites.downloads
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("Error saving person: \(error)")
        }
        favoritePhotosTableView.reloadData()
    }
}
