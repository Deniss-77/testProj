//
//  ImagesResponseModel.swift
//  testProj
//
//  Created by Roman Mokh on 27.03.2024.
//

import Foundation

struct ImagesResponseModel: Codable {
    
    let photos: PhotosInfo?
}

struct PhotosInfo: Codable {
    
    let page: Int?
    let pages: Int?
    let perpage: Int?
    let total: Int?
    let photo: [Photo]?
}

struct Photo: Codable {
    
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
