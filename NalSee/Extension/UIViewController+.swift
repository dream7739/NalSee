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
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func presentOptionAlert(_ title: String?, _ message: String?, _ actionTitle: String?, _ completion: @escaping (UIAlertAction) -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: actionTitle, style: .default, handler: completion)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

