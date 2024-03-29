//
//  MainViewCollectionCell.swift
//  testProj
//
//  Created by Roman Mokh on 27.03.2024.
//

import UIKit

final class MainViewCollectionCell: UICollectionViewCell {
    
    // MARK: Struct
    
    struct MainViewCollectionCellModel {
        let imageUrl: String // ссылка для получения картинки
    }
    
    // MARK: Visual components
    
    private let cellContentView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let iconImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    // MARK: Initialize cell
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupLayout()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    // конфигурация ячейки
    func configure(model: MainViewCollectionCellModel) {
        
        // установка картинки
        let imageDownloadURLString = model.imageUrl
        let url = URL(string: imageDownloadURLString)
        
        self.iconImageView.sd_setImage(with: url) { [weak self] image, error, cache, url in
            self?.iconImageView.image = image != nil ? image : UIImage()
        }
    }
    
    // MARK: Private methods
    
    func setupLayout() {
        
        // add subViews
        self.contentView.addSubview(self.cellContentView)
        self.cellContentView.addSubview(self.iconImageView)
    }
    
    // установка констрейнтов
    func setupConstraints() {
        
        self.cellContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.iconImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.right.left.equalToSuperview()
        }
    }
}
