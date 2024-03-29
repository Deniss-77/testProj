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

final class DetailedViewModel {
    
    // MARK: Struct
    
    struct DetailedViewStruct {
        
        var imageUrl: String? // ссылка для получения картинки
    }
    
    // MARK: Properties
    
    private lazy var detailedDataModel: DetailedViewStruct = DetailedViewStruct()
}

// MARK: реализация протокола DetailedViewModelProtocol

extension DetailedViewModel: DetailedViewModelProtocol {
    
    // сохранение url
    func saveUrl(url: String) {
        self.detailedDataModel.imageUrl = url
    }
    
    // получение url
    func fetchUrl() -> String? {
        return self.detailedDataModel.imageUrl
    }
}
