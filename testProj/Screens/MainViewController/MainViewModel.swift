//
//  MainViewModel.swift
//  testProj
//
//  Created by Roman Mokh on 27.03.2024.
//

import UIKit

protocol MainViewModelProtocol: MainViewModelNavigationProtocol,
                                MainViewModelLanProtocol {
    
    func fetchCountOgPage() -> Int
    func fetchCollectionViewModelsCount() -> Int
    func fetchCollectionViewCellModel(indexPath: IndexPath) -> MainViewCollectionCell.MainViewCollectionCellModel
    func fetchCollectionType() -> CollectionType
    func changeCollectionType()
    func incrementCountOfPage()
    
    // binding
    var didFetchData: (() -> Void)? { get set }
    var didFetchDataWithFailer: ((Error) -> Void)? { get set }
}

// протокол навигации
protocol MainViewModelNavigationProtocol: AnyObject {
    func moveToDetailViewController(with url: String)
}

// протокол сработы с запросами
protocol MainViewModelLanProtocol: AnyObject {
    func fetchImages()
}

final class MainViewModel: MainViewModelProtocol {
    
    // MARK: Struct
    
    struct MainViewStruct {
        var photos: [Photo] = [] // картинки
    }
    
    // MARK: Properties
    
    // closures
    var didFetchData: (() -> Void)?
    var didFetchDataWithFailer: ((Error) -> Void)?
    
    private var router: MainViewRouterProtocol? // роутер
    private lazy var mainDataModel: MainViewStruct = MainViewStruct() // моделька данных экрана
    
    // кол-во страниц
    private var countOfPage: Int = 1
    
    // коллекция
    var collectionDirector: MainViewCollectionDirectorProtocol? // директор по построению коллекции
    private lazy var collectionViewModels: [MainViewCollectionCell.MainViewCollectionCellModel] = [] // модельки ячеек коллекции
    private var collectionType: CollectionType = .vertical // тип коллекции
    
    // MARK: Initializer
    
    init(router: MainViewRouterProtocol) {
        self.router = router
    }
    
    // MARK: Methods
    
    // получение кол-ва страниц
    func fetchCountOgPage() -> Int {
        return self.countOfPage
    }
    
    // получение кол-ва моделек ячеек
    func fetchCollectionViewModelsCount() -> Int {
        return self.collectionViewModels.count
    }
    
    // получение модели ячейки по indexPath
    func fetchCollectionViewCellModel(indexPath: IndexPath) -> MainViewCollectionCell.MainViewCollectionCellModel {
        return self.collectionViewModels[indexPath.item]
    }
    
    // получение типа внешнего вида коллекции
    func fetchCollectionType() -> CollectionType {
        return self.collectionType
    }
    
    // изменение внешнего вида коллекции
    func changeCollectionType() {
        self.collectionType = self.collectionType == .vertical ? .grid : .vertical
    }
    
    // увеличиваем кол-во страниц
    func incrementCountOfPage() {
        self.countOfPage += 1
    }
    
    // MARK: Private methods
    
    // получение collectionViewModels на основе полученных данных
    private func constructCollectionView() {
        self.collectionViewModels = self.collectionDirector?.constructCollectionViewModels(by: self.mainDataModel) ?? []
    }
}

// MARK: реализация протокола MainViewModelNavigationProtocol

extension MainViewModel: MainViewModelNavigationProtocol {
    
    // переход на детальный экран
    func moveToDetailViewController(with url: String) {
        self.router?.routeToDetailedViewController(with: url)
    }
}

// MARK: реализация протокола MainViewModelLanProtocol

extension MainViewModel: MainViewModelLanProtocol {
    
    // получение картинок
    func fetchImages() {
        
        Task {
            do {
                
                let photos = try await ImagesService().fetchImages(page: self.countOfPage) ?? []
                self.mainDataModel.photos.append(contentsOf: photos)
                self.constructCollectionView()
                self.didFetchData?()
                
            } catch {
                self.didFetchDataWithFailer?(error)
            }
        }
    }
}
