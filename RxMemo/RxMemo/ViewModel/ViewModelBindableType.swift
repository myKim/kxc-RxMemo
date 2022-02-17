//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by 김명유 on 2022/02/17.
//

import UIKit

protocol ViewModelBindableType {
    // ViewModel 의 타입은 ViewController 마다 달라지기 때문에 Protocol을 Generic 하게 만들어야 한다.
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

extension ViewModelBindableType where Self: UIViewController {
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        
        bindViewModel()
    }
}
