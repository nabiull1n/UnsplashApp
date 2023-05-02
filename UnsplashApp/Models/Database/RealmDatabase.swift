//
//  RealmDatabase.swift
//  UnsplashApp
//
//  Created by Денис Набиуллин on 13.04.2023.
//
import Foundation
import RealmSwift

class RealmDatabase: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var downloads: Int = Int()
}
