//
//  TitleCollectionViewHeader.swift
//  TongueLaw
//
//  Created by 최승범 on 10/9/24.
//

import UIKit
import SnapKit

final class TitleCollectionViewHeader: UICollectionReusableView {
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - TitleCollectionViewHeader Method
extension TitleCollectionViewHeader {
    
    func updateContent(title: String) {
        titleLabel.text = title
    }
    
}

//MARK: - TitleCollectionViewHeader Configuration
extension TitleCollectionViewHeader: BaseViewProtocol {
    
    func configureHierarchy() {
        addSubview(titleLabel)
    }
    
    func configureUI() {
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(8)
            make.verticalEdges.equalTo(self.snp.verticalEdges)
        }
    }
    
}
