//
//  Identifier+Extension.swift
//  TongueLaw
//
//  Created by 최승범 on 10/9/24.
//

import UIKit

protocol ReuseableIdentifier {
    static var identifier: String { get }
}

extension ReuseableIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIView: ReuseableIdentifier {}
extension UIViewController: ReuseableIdentifier {}
