//
//  ReusableProtocol.swift
//  NalSee
//
//  Created by 홍정민 on 7/13/24.
//

import UIKit

protocol ReusableProtocol {
    static var reuseIdentifier: String { get }
}

extension UIView: ReusableProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
