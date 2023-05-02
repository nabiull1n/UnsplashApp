//
//  HomeStructure.swift
//  UnsplashApp
//
//  Created by Денис Набиуллин on 01.04.2023.
//

struct UnsplashPhoto: Decodable {
    let id: String?
    let regular: String?
    let name: String?
    let createdAt: String?
    let location: String?
    let downloads: Int?
    let height: Int?
    let width: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case regular
        case name
        case createdAt = "created_at"
        case location
        case downloads
        case height
        case width
    }
}
