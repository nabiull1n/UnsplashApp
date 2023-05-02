//
//  SearchRequest.swift
//  UnsplashApp
//
//  Created by Денис Набиуллин on 05.04.2023.
//

import Foundation
import Alamofire

struct SearchRequest {
    static let accessKey = "pCznb1ydZUKfzlsHR0YMKAuDaxNj-ok1qpnIdpns5g8"
    static func searchPhotos(name: String, completion: @escaping (UnsplashPhoto?) -> Void) {
        let url = "https://api.unsplash.com/search/photos?"
        let parameters: [String: Any] = [
            "query": name,
            "client_id": accessKey
        ]
        AF.request(url, parameters: parameters).responseJSON { response in
            switch response.result {
                
            case .success(let json):
                guard let jsonArray = json as? [String: Any],
                      let result = jsonArray["results"] as? [[String:Any]]
                else { return }
                for jsonObject in result {
                    guard let id = jsonObject["id"] as? String,
                          let urlsArray = jsonObject["urls"] as? [String: Any],
                          let regular = urlsArray["regular"] as? String,
                          let userArray = jsonObject["user"] as? [String: Any],
                          let user = userArray["name"] as? String,
                          let created = jsonObject["created_at"] as? String,
                          let height = jsonObject["height"] as? Int,
                          let width = jsonObject["width"] as? Int
                    else { return }
                    
                    let infoPhoto = UnsplashPhoto(id: id, regular: regular, name: user, createdAt: created, location: "nil", downloads: 0, height: height, width: width)
                    completion(infoPhoto)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
