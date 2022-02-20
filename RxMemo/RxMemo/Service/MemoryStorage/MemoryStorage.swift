//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by 김명유 on 2022/02/17.
//

import Foundation
import RxSwift

class MemoryStorage: MemoStorageType {
    // 더미 데이터, 클래스 외부에서 접근할 필요가 없기 때문에 private 로 구현
    // 배열의 상태가 업데이트 되면 새로운 Next 이벤트를 방출해야 한다.
    // Behavior Subject로 만들어야 한다.
    private var list = [
        Memo(content: "Hello, RxSwift", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "Lorem ipsum", insertDate: Date().addingTimeInterval(-20))
    ]
    
    private lazy var sectionModel = MemoSectionModel(model: 0, items: list)
    
    // 기본값을 list 배열로 설정하기 위해서 lazy로 선언, 외부에서 접근할 필요가 없기 때문에 private 로 선언
    private lazy var store = BehaviorSubject<[MemoSectionModel]>(value: [sectionModel])
    
    
    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        let memo = Memo(content: content)
        sectionModel.items.insert(memo, at: 0)
        
        store.onNext([sectionModel])
        
        return Observable.just(memo)
    }
    
    @discardableResult
    func memoList() -> Observable<[MemoSectionModel]> {
        return store
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        let updated = Memo(original: memo, updatedContent: content)
        
        if let index = sectionModel.items.firstIndex(where: { $0 == memo }) {
            sectionModel.items.remove(at: index)
            sectionModel.items.insert(updated, at: index)
        }
        
        store.onNext([sectionModel])
        
        return Observable.just(updated)
    }
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        if let index = sectionModel.items.firstIndex(where: { $0 == memo }) {
            sectionModel.items.remove(at: index)
        }
        
        store.onNext([sectionModel])
        
        return Observable.just(memo)
    }
}
