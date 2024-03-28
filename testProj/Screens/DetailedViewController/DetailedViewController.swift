//
//  DetailedViewController.swift
//  testProj
//
//  Created by Roman Mokh on 27.03.2024.
//

import UIKit

protocol DetailedViewProtocol: AnyObject {
    
}

final class DetailedViewController: UIViewController {
    
    private let backView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private let imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    // MARK: Properties
    
    var viewModel: DetailedViewModelProtocol?
    
    // MARK: Life cycle viewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        self.setupConstraints()
        self.setImage()
    }
    
    // MARK: Private methods
    
    private func setupLayout() {
        
        // заголовок экрана
        self.title = "Картинка"
        
        // add subViews
        self.view.addSubview(self.backView)
        self.backView.addSubview(self.imageView)
        
        // backgroundColor
        self.view.backgroundColor = .white
    }
    
    // установка констрейнтов
    private func setupConstraints() {
        
        self.backView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.imageView.snp.makeConstraints { make in
            
            make.centerX.centerY.equalToSuperview()
            make.top.left.right.bottom.equalToSuperview().inset(20)
        }
    }
    
    // установка картинки
    private func setImage() {
        
        guard let imageDownloadURLString = self.viewModel?.fetchUrl() else { return }
        
        let url = URL(string: imageDownloadURLString)
        
        self.imageView.sd_setImage(with: url) { [weak self] image, error, cache, url in
            self?.imageView.image = image != nil ? image : UIImage()
        }
    }
}

// MARK: реализация протокола DetailedViewProtocol

extension DetailedViewController: DetailedViewProtocol {
    
}
