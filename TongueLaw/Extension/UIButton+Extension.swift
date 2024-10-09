//
//  UIButton+Extension.swift
//  TongueLaw
//
//  Created by 최승범 on 10/8/24.
//

import UIKit

extension UIButton {
    
    func buttonStyle(type: DesignOfButton) {
        var configuration = UIButton.Configuration.filled()

        configuration.title = type.title
        configuration.titleAlignment = .center
        configuration.baseBackgroundColor = type.backGroundColor
        configuration.baseForegroundColor = type.tintColor
        configuration.cornerStyle = .small
        configuration.image = UIImage(systemName: type.imageName)
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12)

        let font = UIFont.systemFont(ofSize: 12)
        let titleAttributes = [NSAttributedString.Key.font: font]
        
        configuration.attributedTitle = AttributedString(type.title, attributes: AttributeContainer(titleAttributes))

        self.configuration = configuration
        layer.cornerRadius = 12
    }
    
}
