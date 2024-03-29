//
//  MainViewController.swift
//  testProj
//
//  Created by Roman Mokh on 27.03.2024.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    
    var navController: UINavigationController? { get }
    
    func operationFailed(_ error: Error)
}

final class MainViewController: UIViewController {
    
    // MARK: Visual components
    
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(MainViewCollectionCell.self,
                                forCellWithReuseIdentifier: MainViewCollectionCell.identifier)
        
        return collectionView
    }()
    
    // MARK: Properties
    
    var viewModel: MainViewModelProtocol?
    
    // MARK: Life cycle viewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        self.setupConstraints()
        self.setDelegates()
        self.fetchData()
    }
    
    // MARK: Private methods
    
    private func setupLayout() {
        
        // заголовок экрана
        self.title = "Главный экран"
        
        // add subViews
        self.view.addSubview(self.collectionView)
        
        // backgroundColor
        self.view.backgroundColor = .white
        
        // установка rightBarButton в navigationBar
        self.setBarButton()
    }
    
    // установка констрейнтов
    private func setupConstraints() {
        
        self.collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    // назначаем делегаты
    private func setDelegates() {
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    // установка rightBarButton в navigationBar
    private func setBarButton() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImageName.iconCollection,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(rightBarButtonClicked))
    }
    
    // получение данных и обновление коллекции
    private func fetchData() {
        
        // получение данных
        self.view.addIndicator()
        self.viewModel?.fetchImages()
        
        // если данные получены
        self.viewModel?.didFetchData = { [weak self] in
            
            // обновление коллекции
            DispatchQueue.main.async {
                
                self?.collectionView.reloadData()
                self?.view.removeIndicator()
            }
        }
        
        // если что-то пошло не так
        self.viewModel?.didFetchDataWithFailer = { [weak self] error in
            self?.operationFailed(error)
        }
    }
    
    // нажатие на rightBarButton в navigationBar
    @objc private func rightBarButtonClicked() {
        
        self.viewModel?.changeCollectionType()
        self.collectionView.reloadData()
    }
}

// MARK: реализация протокола UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        guard let count = self.viewModel?.fetchCollectionViewModelsCount() else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cellModel = self.viewModel?.fetchCollectionViewCellModel(indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewCollectionCell.identifier,
                                                                for: indexPath) as! MainViewCollectionCell
        collectionCell.configure(model: cellModel)
        
        return collectionCell
    }
}

// MARK: реализация протокола UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        guard let url = self.viewModel?.fetchCollectionViewCellModel(indexPath: indexPath).imageUrl else { return }
        self.viewModel?.moveToDetailViewController(with: url)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        guard let modelsCount = self.viewModel?.fetchCollectionViewModelsCount(),
              let countOfPage = self.viewModel?.fetchCountOfPage(),
              countOfPage < 100, // 100 - максимальное кол-во страниц
              indexPath.item == modelsCount - 1 else { return }
        
        self.viewModel?.incrementCountOfPage()
        // получение данных
        self.fetchData()
    }
}

// MARK: реализация протокола UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        switch self.viewModel?.fetchCollectionType() {
            
        case .vertical:
            
            width = self.collectionView.frame.width
            height = 180
            break
            
        case .grid:
            
            let itemsPerRow: CGFloat = 2
            
            width = (self.collectionView.frame.width - 16) / itemsPerRow
            height = 180
            break
            
        case .none:
            break
        }
        
        return CGSize(width: width,
                      height: height)
    }
}

// MARK: реализация протокола MainViewProtocol

extension MainViewController: MainViewProtocol {
    
    // MARK: Properties
    
    var navController: UINavigationController? {
        return self.navigationController
    }
    
    // MARK: Methods
    
    // если что-то пошло не так
    func operationFailed(_ error: Error) {
        self.alert(title: error.localizedDescription)
    }
}
