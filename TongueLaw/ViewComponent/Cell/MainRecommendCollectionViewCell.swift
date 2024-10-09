//
//  MainRecommendCollectionViewCell.swift
//  TongueLaw
//
//  Created by 최승범 on 10/9/24.
//

import UIKit

final class MainRecommendCollectionViewCell: UICollectionViewCell {
    
    private let poster = UIImageView()
    private let genreTextView = UITextView()
    private let buttonStackView = UIStackView()
    private let playButton = UIButton()
    private let addDownloadListButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - MainRecommendCollectionViewCell Method
extension MainRecommendCollectionViewCell {
    
    //TODO: - Model 확정시 수정 필요
    func updateContent(_ image: UIImage) {
        
    }
    
}

//MARK: - MovieListCollectionViewCell Configuration
extension MainRecommendCollectionViewCell: BaseViewProtocol {
    
    func configureHierarchy() {
        contentView.addSubview(poster)
        contentView.addSubview(genreTextView)
        buttonStackView.addArrangedSubview(playButton)
        buttonStackView.addArrangedSubview(addDownloadListButton)
    }
    
    func configureUI() {
        poster.backgroundColor = .gray
        poster.layer.cornerRadius = 12
        
        playButton.buttonStyle(type: .play)
        playButton.buttonStyle(type: .downloadList)
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 8
    }
    
    func configureLayout() {
        poster.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(poster.snp.bottom).inset(12)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(contentView.snp.width).inset(8)
        }
        
        genreTextView.snp.makeConstraints { make in
            make.bottom.equalTo(buttonStackView.snp.top).offset(16)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
        }
    }
    
}


