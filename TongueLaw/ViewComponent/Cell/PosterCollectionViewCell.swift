//
//  PosterCollectionViewCell.swift
//  TongueLaw
//
//  Created by 최승범 on 10/8/24.
//

import UIKit
import Kingfisher

final class PosterCollectionViewCell: UICollectionViewCell {
    
    private let poster = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - PosterCollectionViewCell Method
extension PosterCollectionViewCell {
    
    func updateContent(_ path: String) {
        poster.kf.setImage(with: TMDBRouter.image(imagePath: path).baseURL)
    }
    
}

//MARK: - PosterCollectionViewCell Configuration
extension PosterCollectionViewCell: BaseViewProtocol {
    
    func configureHierarchy() {
        contentView.addSubview(poster)
    }
    
    func configureUI() {
        poster.backgroundColor = .gray
        poster.layer.cornerRadius = 8
    }
    
    func configureLayout() {
        poster.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }
    
}
