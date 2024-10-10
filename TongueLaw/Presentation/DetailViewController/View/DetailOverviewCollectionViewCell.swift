//
//  OverviewCollectionViewCell.swift
//  TongueLaw
//
//  Created by 최승범 on 10/10/24.
//

import UIKit
import SnapKit

final class DetailOverviewCollectionViewCell: UICollectionViewCell {

    private let overviewLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Method
extension DetailOverviewCollectionViewCell {
    
    func updateContent(data: String) {
        overviewLabel.text = data
    }
    
}

//MARK: - Configuration
extension DetailOverviewCollectionViewCell: BaseViewProtocol {
    
    func configureHierarchy() {
        contentView.addSubview(overviewLabel)
    }
    
    func configureUI() {
        overviewLabel.numberOfLines = 5
        overviewLabel.font = .systemFont(ofSize: 15)
        overviewLabel.textColor = .lightGray
    }
    
    func configureLayout() {
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
    }
    
}
