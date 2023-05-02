//
//  NetworkRequest.swift
//  UnsplashApp
//
//  Created by Денис Набиуллин on 30.03.2023.
//

import Foundation
import Alamofire

struct UnsplashAPI {
    static let accessKey = "h4ewq4i3cVPce6ANSsiZITtW9bO9fmUcYw1bfQCieF4"
    static func loadRandomPhotos(count: Int, completion: @escaping (UnsplashPhoto) -> Void) {
        let url = "https://api.unsplash.com/photos/random"
        let parameters: [String: Any] = [
            "count": count,
            "client_id": accessKey
        ]
        AF.request(url, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let json):
                guard let jsonArray = json as? [[String: Any]] else { return }
                for jsonObject in jsonArray {
                    guard let id = jsonObject["id"] as? String,
                          let urlsArray = jsonObject["urls"] as? [String: Any],
                          let photos = urlsArray["regular"] as? String,
                          let userArray = jsonObject["user"] as? [String: Any],
                          let name = userArray["name"] as? String,
                          let created = jsonObject["created_at"] as? String,
                          let downloads = jsonObject["downloads"] as? Int,
                          let height = jsonObject["height"] as? Int,
                          let width = jsonObject["width"] as? Int
                    else { return }
                    let info = UnsplashPhoto(id: id, regular: photos, name: name, createdAt: created, location:"", downloads: downloads , height: height, width: width)
                    completion(info)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
