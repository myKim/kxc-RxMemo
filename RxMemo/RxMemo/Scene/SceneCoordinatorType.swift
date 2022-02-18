//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by 김명유 on 2022/02/18.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
    
    @discardableResult
    func close(animated: Bool) -> Completable
}
