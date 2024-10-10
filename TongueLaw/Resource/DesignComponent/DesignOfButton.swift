//
//  DesignOfButton.swift
//  TongueLaw
//
//  Created by 최승범 on 10/8/24.
//

import UIKit

enum DesignOfButton {
    
    case play
    case favorite
    case save
    case cancel
    case search
    
    var title: String {
        switch self {
        case .play:
            "재생"
        case .favorite:
            "내가 찜한 리스트"
        case .save:
            "저장"
        case .cancel:
            "취소"
        case .search:
            "검색"
        }
    }
    
    var imageName: String {
        switch self {
        case .play:
            "play.fill"
        case .favorite:
            "plus"
        case .save:
            "square.and.arrow.down"
        case .cancel:
            "xmark"
        case .search:
            "magnifyingglass"
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .play:
            .black
        case .favorite:
            .white
        case .save:
            .white
        case .cancel:
            .white
        case .search:
            .white
        }
    }
    
    var backGroundColor: UIColor {
        switch self {
        case .play:
            .white
        case .favorite:
             #colorLiteral(red: 0.1907704771, green: 0.20546031, blue: 0.2267445326, alpha: 1)
        case .save:
             #colorLiteral(red: 0.1907704771, green: 0.20546031, blue: 0.2267445326, alpha: 1)
        case .cancel:
             #colorLiteral(red: 0.1907704771, green: 0.20546031, blue: 0.2267445326, alpha: 1).withAlphaComponent(0.5)
        case .search:
            .clear
        }
    }
    
}
