//
//  MemoStorageType.swift
//  RxMemo
//
//  Created by 김명유 on 2022/02/17.
//

import Foundation
import RxSwift

protocol MemoStorageType {
    @discardableResult // 작업 결과가 필요 없는 경우
    func createMemo(content: String) -> Observable<Memo> // 구독자가 작업 결과를 원하는데로 처리할 수 있음
    
    @discardableResult
    func memoList() -> Observable<[Memo]>
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo>
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo>
}
