//
//  ImagesService.swift
//  testProj
//
//  Created by Roman Mokh on 27.03.2024.
//

import Foundation
import Alamofire

final class ImagesService {
    
    // получение картинок
    func fetchImages(page: Int) async throws -> [Photo]? {
        
        let apiKey: String = "a7b722ad8eea55d200b59b5b1bf3bded"
        let url: String = "https://www.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=\(apiKey)&per_page=10&page=\(page)&format=json&nojsoncallback=1"
        
        
        return try await withCheckedThrowingContinuation { continuation in
            
            AF.request(url,
                       method: .get,
                       encoding: JSONEncoding.default).responseDecodable(of: ImagesResponseModel.self) { response in
                
                switch response.result {
                    
                case .success(let success):
                    
                    let photos = success.photos?.photo
                    continuation.resume(returning: photos ?? [])
                    break
                    
                case .failure(let error):
                    
                    continuation.resume(throwing: error)
                    break
                }
            }
        }
    }
}
