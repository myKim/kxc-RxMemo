//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by 김명유 on 2022/02/17.
//

import Foundation
import RxSwift
import RxCocoa

// 메모 목록 화면에서 사용하는 뷰 모델
class MemoListViewModel: CommonViewModel {
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
}
