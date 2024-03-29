//
//  ImagesResponseModel.swift
//  testProj
//
//  Created by Roman Mokh on 27.03.2024.
//

import Foundation

struct ImagesResponseModel: Decodable {
    
    let photos: PhotosInfo?
}

struct PhotosInfo: Decodable {
    
    enum CodingKeys: String, CodingKey {
        
        case page
        case pages
        case perpage
        case total
        case photos = "photo"
    }
    
    let page: Int?
    let pages: Int?
    let perpage: Int?
    let total: Int?
    let photos: [Photo]?
}

struct Photo: Decodable {
    
    let id: String?
    let owner: String?
    let secret: String?
    let server: String?
    let farm: Int?
    let title: String?
    let ispublic: Int?
    let isfriend: Int?
    let isfamily: Int?
}
