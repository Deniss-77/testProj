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
    
    private let backView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        self.view.addSubview(self.backView)
        self.backView.addSubview(self.collectionView)
        
        // backgroundColor
        self.view.backgroundColor = .white
        
        // установка rightBarButton в navigationBar
        self.setBarButton()
    }
    
    // установка констрейнтов
    private func setupConstraints() {
        
        self.backView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
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
                                                                 action: #selector(buttonImageClicked))
    }
    
    // получение данных и обновление коллекции
    private func fetchData() {
        
        // получение данных
        self.view.addActivityIndicator()
        self.viewModel?.fetchImages()
        
        // если данные получены
        self.viewModel?.didFetchData = { [weak self] in
            
            // обновление коллекции
            DispatchQueue.main.async {
                
                self?.collectionView.reloadData()
                self?.view.removeActivityIndicator()
            }
        }
        
        // если что-то пошло не так
        self.viewModel?.didFetchDataWithFailer = { [weak self] error in
            
            self?.operationFailed(error)
        }
    }
    
    // нажатие на rightBarButton в navigationBar
    @objc private func buttonImageClicked() {
        
        self.viewModel?.changeCollectionType()
        self.collectionView.reloadData()
    }
}

// MARK: UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = self.viewModel?.fetchCollectionViewModelsCount() else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let currentModel = self.viewModel?.fetchCollectionViewCellModel(indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewCollectionCell.identifier,
                                                                for: indexPath) as! MainViewCollectionCell
        collectionCell.configure(model: currentModel)
        
        return collectionCell
    }
}

// MARK: UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        guard let url = self.viewModel?.fetchCollectionViewCellModel(indexPath: indexPath).imageUrl else { return }
        self.viewModel?.moveToDetailViewController(with: url)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let itemsCount = self.viewModel?.fetchCollectionViewModelsCount(),
              let countOfPage = self.viewModel?.fetchCountOgPage(),
              countOfPage < 100, // 100 - максимальное ко-во страниц
              indexPath.item == itemsCount - 1  else { return }
        
        self.viewModel?.incrementCountOfPage()
        
        // запоминаем последнее место скролла и оставнавливаем его
        let currentContentOffset = collectionView.contentOffset
        collectionView.setContentOffset(currentContentOffset, animated: true)
        
        self.fetchData()
    }
}

// MARK: UICollectionViewDelegateFlowLayout

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
            
        case .grid:
            
            let itemsPerRow: CGFloat = 2
            
            width = (self.collectionView.frame.width - 16) / itemsPerRow
            height = 180
            
        case .none:
            break
        }
        
        return CGSize(width: width,
                      height: height)
    }
}

// MARK: реализация протокола MainViewProtocol

extension MainViewController: MainViewProtocol {
    
    var navController: UINavigationController? {
        return self.navigationController
    }
    
    // если что-то пошло не так
    func operationFailed(_ error: Error) {
        self.alert(title: error.localizedDescription)
    }
}
