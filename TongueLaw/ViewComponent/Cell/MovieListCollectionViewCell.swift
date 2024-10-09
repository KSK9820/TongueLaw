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
    
    override init(frame: CGRect) {
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
        playIconImageView.tintColor = .black
    }
    
    func configureLayout() {
        poster.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.leading.equalToSuperview().inset(8)
            make.height.equalTo(100)
            make.width.equalTo(poster.snp.height).multipliedBy(1.2)
        }
        
        playIconImageView.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.centerY.equalTo(poster.snp.centerY)
            make.trailing.equalToSuperview().inset(8)
        }
        
        titleView.snp.makeConstraints { make in
            make.leading.equalTo(poster.snp.trailing).offset(20)
            make.trailing.equalTo(playIconImageView.snp.leading).inset(20)
        }
    }
    
}
