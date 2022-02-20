//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by 김명유 on 2022/02/17.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoComposeViewController: UIViewController, ViewModelBindableType {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var contentTextView: UITextView!
    
    
    var viewModel: MemoComposeViewModel!
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.initialText
            .drive(contentTextView.rx.text)
            .disposed(by: rx.disposeBag)
        
        cancelButton.rx.action = viewModel.cancelAction
        
        saveButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(contentTextView.rx.text.orEmpty)
            .bind(to: viewModel.saveAction.inputs)
            .disposed(by: rx.disposeBag)
        
        let willShowObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue } // compactMap을 사용하는 이유는 optional을 자동으로 unwrapping 하기 위해서이다. 이렇게 구현하면 notificataion이 전달되는 시점마다 구독자에게 키보드 높이가 전달된다.
            .map { $0.cgRectValue.height } // map 연산자를 활용해서 최종적으로 키보드 높이를 방출
        
        let willHideObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { noti -> CGFloat in 0 }
        
        let keyboardObservable = Observable.merge(willShowObservable, willHideObservable)
            .share()
        
        keyboardObservable
            .toContentInset(of: contentTextView)
            .bind(to: contentTextView.rx.contentInset)
            .disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
}

extension ObservableType where Element == CGFloat {
    func toContentInset(of textView: UITextView) -> Observable<UIEdgeInsets> {
        return map { height in
            var inset = textView.contentInset
            inset.bottom = height
            return inset
        }
    }
}
