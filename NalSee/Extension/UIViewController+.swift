//
//  UIViewController+.swift
//  NalSee
//
//  Created by 홍정민 on 7/19/24.
//

import UIKit

extension UIViewController {
    func presentAlert(_ title: String?, _ message: String?, _ actionTitle: String?, _ completion: @escaping (UIAlertAction) -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: completion)
        present(alert, animated: true)
    }
}

