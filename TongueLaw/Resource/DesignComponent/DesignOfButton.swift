//
//  DesignOfButton.swift
//  TongueLaw
//
//  Created by 최승범 on 10/8/24.
//

import UIKit

enum DesignOfButton {
    case play
    case downloadList
    case save
    
    var title: String {
        switch self {
        case .play:
            return "재생"
        case .downloadList:
            return "내가 찜한 리스트"
        case .save:
            return "저장"
        }
    }
    
    var imageName: String {
        switch self {
        case .play:
            return "play.fill"
        case .downloadList:
            return "plus"
        case .save:
            return "square.and.arrow.down"
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .play:
            return .black
        case .downloadList:
            return .white
        case .save:
            return .white
        }
    }
    
    var backGroundColor: UIColor {
        switch self {
        case .play:
            return .white
        case .downloadList:
            return #colorLiteral(red: 0.1907704771, green: 0.20546031, blue: 0.2267445326, alpha: 1)
        case .save:
            return #colorLiteral(red: 0.1907704771, green: 0.20546031, blue: 0.2267445326, alpha: 1)
        }
    }
}
