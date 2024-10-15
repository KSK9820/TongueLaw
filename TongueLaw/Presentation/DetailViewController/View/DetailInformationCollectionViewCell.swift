//
//  DetailInformationCollectionViewCell.swift
//  TongueLaw
//
//  Created by 최승범 on 10/10/24.
//

import UIKit
import SnapKit

final class DetailInformationCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let genreLabel = UILabel()
    private let scoreStarImageView = UIImageView()
    private let voteAverageLabel = UILabel()
    private let playButton = UIButton()
    private let saveButton = UIButton()
    var showVideo: () -> () = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Method

extension DetailInformationCollectionViewCell {
    
    func updateContent(title: String, date: String, genreIDs: [Int], voteAverage: Double,  genreList: [Int: String]) {
        titleLabel.text = title
        dateLabel.text = date
        genreLabel.text = getGenreNames(genreIDs: genreIDs, genreList: genreList)
        voteAverageLabel.text = String(format: "%.1f", voteAverage)
    }
    
    private func getGenreNames(genreIDs: [Int], genreList: [Int: String]) -> String {
        let genreNames = genreIDs.compactMap { genreList[$0] }
        return genreNames.joined(separator: ", ")
    }
    
    @objc private func playButtonClicked() {
        showVideo()
    }
}

//MARK: - Configuration
extension DetailInformationCollectionViewCell: BaseViewProtocol {
    
    func configureHierarchy() {
        contentView.addSubview(playButton)
        contentView.addSubview(saveButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(scoreStarImageView)
        contentView.addSubview(voteAverageLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(genreLabel)
    }
    
    func configureUI() {
        titleLabel.text = "제목"
        scoreStarImageView.image = UIImage(systemName: "star.fill")
        scoreStarImageView.tintColor = #colorLiteral(red: 1, green: 0.8878700137, blue: 0.2636117339, alpha: 1)
        
        voteAverageLabel.font = .systemFont(ofSize: 14)
        voteAverageLabel.textColor = .lightGray
        
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .lightGray
        
        genreLabel.font = .systemFont(ofSize: 14)
        genreLabel.textColor = .lightGray
        
        playButton.buttonStyle(type: .play)
        saveButton.buttonStyle(type: .save)
    }
    
    func configureLayout() {
        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges)
            make.height.equalTo(44)
        }
        
        playButton.snp.makeConstraints { make in
            make.bottom.equalTo(saveButton.snp.top).offset(-8)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges)
            make.height.equalTo(44)
        }
    
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading)
            make.top.equalTo(contentView.snp.top).offset(8)
            make.height.equalTo(20)
        }
    
        scoreStarImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalTo(playButton.snp.top).offset(-8)
            make.height.equalTo(20)
        }
        
        voteAverageLabel.snp.makeConstraints { make in
            make.leading.equalTo(scoreStarImageView.snp.trailing).offset(8)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalTo(playButton.snp.top).offset(-8)
            make.height.equalTo(20)
        
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(voteAverageLabel.snp.trailing).offset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalTo(playButton.snp.top).offset(-8)
            make.height.equalTo(20)
        
        }
        
        genreLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalTo(playButton.snp.top).offset(-8)
            make.height.equalTo(20)
        
        }
    }
    
    func configureGestureAndButtonActions() {
        playButton.addTarget(self, action: #selector(playButtonClicked), for: .touchUpInside)
    }

}

