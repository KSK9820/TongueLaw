//
//  ReuseableIdentifierProtocol.swift
//  TongueLaw
//
//  Created by 최승범 on 10/9/24.
//

import UIKit

protocol ReuseableIdentifierProtocol {
    static var identifier: String { get }
}

extension ReuseableIdentifierProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIView: ReuseableIdentifierProtocol {}
extension UIViewController: ReuseableIdentifierProtocol {}
