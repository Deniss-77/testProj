//
//  MainViewModel.swift
//  testProj
//
//  Created by Roman Mokh on 27.03.2024.
//

import Foundation

protocol MainViewModelProtocol: MainViewModelNavigationProtocol,
                                MainViewModelLanProtocol {
    
    // bindings
    var didFetchData: (() -> Void)? { get set }
    var didFetchDataWithFailer: ((Error) -> Void)? { get set }
    
    func fetchCountOfPage() -> Int
    func fetchCollectionViewModelsCount() -> Int
    func fetchCollectionViewCellModel(indexPath: IndexPath) -> MainViewCollectionCell.MainViewCollectionCellModel
    func fetchCollectionType() -> CollectionType
    func changeCollectionType()
    func incrementCountOfPage()
}

// протокол навигации
protocol MainViewModelNavigationProtocol: AnyObject {
    func moveToDetailViewController(with url: String)
}

// протокол работы с запросами
protocol MainViewModelLanProtocol: AnyObject {
    func fetchImages()
}

final class MainViewModel {
    
    // MARK: Struct
    
    struct MainViewStruct {
        
        var photos: [Photo] = [] // картинки
        var countOfPage: Int = 1 // кол-во страниц
    }
    
    // MARK: Properties
    
    // closures
    var didFetchData: (() -> Void)?
    var didFetchDataWithFailer: ((Error) -> Void)?
    
    // роутер
    private let router: MainViewRouterProtocol
    // сетевой слой
    private let imagesNetwork: ImagesNetworkServiceProtocol
    // моделька данных экрана
    private lazy var mainDataModel: MainViewStruct = MainViewStruct()
    // коллекция
    var collectionDirector: MainViewCollectionDirectorProtocol? // директор по построению коллекции
    private lazy var collectionViewModels: [MainViewCollectionCell.MainViewCollectionCellModel] = [] // модельки ячеек коллекции
    private lazy var collectionType: CollectionType = .vertical // тип коллекции
    
    // MARK: Initializer
    
    init(router: MainViewRouterProtocol,
         imagesNetwork: ImagesNetworkServiceProtocol) {
        
        self.router = router
        self.imagesNetwork = imagesNetwork
    }
    
    // MARK: Private methods
    
    // формирование collectionViewModels на основе полученных данных
    private func constructCollectionView() {
        self.collectionViewModels = self.collectionDirector?.constructCollectionViewModels(by: self.mainDataModel) ?? []
    }
}

// MARK: реализация протокола MainViewModelProtocol

extension MainViewModel: MainViewModelProtocol {
    
    // получение кол-ва страниц
    func fetchCountOfPage() -> Int {
        return self.mainDataModel.countOfPage
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
        self.mainDataModel.countOfPage += 1
    }
}

// MARK: реализация протокола MainViewModelNavigationProtocol

extension MainViewModel: MainViewModelNavigationProtocol {
    
    // переход на детальный экран
    func moveToDetailViewController(with url: String) {
        self.router.routeToDetailedViewController(with: url)
    }
}

// MARK: реализация протокола MainViewModelLanProtocol

extension MainViewModel: MainViewModelLanProtocol {
    
    // получение картинок
    func fetchImages() {
        
        Task {
            do {
                let photos = try await self.imagesNetwork.fetchImages(page: self.mainDataModel.countOfPage)
                self.mainDataModel.photos.append(contentsOf: photos)
                // формирование моделек ячеек
                self.constructCollectionView()
                self.didFetchData?()
                
            } catch {
                self.didFetchDataWithFailer?(error)
            }
        }
    }
}
