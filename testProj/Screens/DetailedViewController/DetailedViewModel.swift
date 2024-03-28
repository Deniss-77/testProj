//
//  DetailedViewModel.swift
//  testProj
//
//  Created by Roman Mokh on 27.03.2024.
//

import Foundation

protocol DetailedViewModelProtocol: AnyObject {
    
    func saveUrl(url: String)
    func fetchUrl() -> String?
}

final class DetailedViewModel: DetailedViewModelProtocol {
    
    // MARK: Struct
    
    struct DetailedStruct {
        
        var imageUrl: String? // ссылка для получения картинки
    }
    
    // MARK: Properties
    
    lazy var detailedDataModel: DetailedStruct = DetailedStruct()
    
    // MARK: Methods
    
    // сохранение url
    func saveUrl(url: String) {
        self.detailedDataModel.imageUrl = url
    }
    
    // получение url
    func fetchUrl() -> String? {
        return self.detailedDataModel.imageUrl
    }
}
