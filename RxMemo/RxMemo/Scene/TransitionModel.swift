//
//  TransitionModel.swift
//  RxMemo
//
//  Created by 김명유 on 2022/02/18.
//

import Foundation
import UIKit

enum TransitionStyle {
    case root // 첫번째 화면
    case push // 새로운 화면을 네비게이션 스택에
    case modal // 새로운 화면을 모달 형식으로 사용할 때
}

enum TranstionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
