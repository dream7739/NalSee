//
//  Observable.swift
//  NalSee
//
//  Created by 홍정민 on 7/15/24.
//

import Foundation

class CObservable<T> {
    var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void){
        self.closure = closure
    }
}
