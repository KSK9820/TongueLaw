//
//  MovieListCollectionViewCell.swift
//  TongueLaw
//
//  Created by 최승범 on 10/8/24.
//

import UIKit

final class MovieListCollectionViewCell: UICollectionViewCell {
    
    private let poster = UIImageView()
    private let titleView = UITextView()
    private let playIconImageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - MovieListCollectionViewCell Method
extension MovieListCollectionViewCell {
    
    //TODO: - Model 확정시 수정 필요
    func updateContent(_ image: UIImage) {
        
    }
    
}

//MARK: - MovieListCollectionViewCell Configuration
extension MovieListCollectionViewCell: BaseViewProtocol {
    
    func configureHierarchy() {
        contentView.addSubview(poster)
        contentView.addSubview(titleView)
        contentView.addSubview(playIconImageView)
    }
    
    func configureUI() {
        poster.backgroundColor = .gray
        poster.layer.cornerRadius = 8
        titleView.textAlignment = .left
        playIconImageView.image = UIImage(systemName: "play.circle")
    }
    
    func configureLayout() {
        poster.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.3)
        }
        
        playIconImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.width.equalTo(playIconImageView.snp.height)
            make.trailing.equalToSuperview().inset(20)
        }
        
        titleView.snp.makeConstraints { make in
            make.leading.equalTo(poster.snp.trailing).offset(20)
            make.trailing.equalTo(playIconImageView.snp.leading).inset(20)
        }
    }
    
}
