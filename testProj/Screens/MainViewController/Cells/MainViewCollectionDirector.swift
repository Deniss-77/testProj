//
//  MainViewCollectionDirector.swift
//  testProj
//
//  Created by Roman Mokh on 27.03.2024.
//

import Foundation

protocol MainViewCollectionDirectorProtocol: AnyObject {
    
    func constructCollectionViewModels(by dataSource: MainViewModel.MainViewStruct) -> [MainViewCollectionCell.MainViewCollectionCellModel]
}

final class MainViewCollectionDirector: MainViewCollectionDirectorProtocol {
    
    // MARK: Properties
    
    weak var viewModel: MainViewModelProtocol?
    
    // MARK: Initializer
    
    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    // MARK: Methods
    
    // получение моделек ячеек коллекции
    func constructCollectionViewModels(by dataSource: MainViewModel.MainViewStruct) -> [MainViewCollectionCell.MainViewCollectionCellModel] {
        
        var models: [MainViewCollectionCell.MainViewCollectionCellModel] = []
        
        dataSource.photos.forEach({ photo in
            
            guard let server = photo.server,
                  let id = photo.id,
                  let secret = photo.secret else { return }
            
            let url = "https://live.staticflickr.com/\(server)/\(id)_\(secret)_b.jpg"
            let mainViewCollectionCell = MainViewCollectionCell.MainViewCollectionCellModel(imageUrl: url)
            
            models.append(mainViewCollectionCell)
        })
        
        return models
    }
}
