//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by 김명유 on 2022/02/18.
//

import Foundation
import RxSwift
import RxCocoa

extension UIViewController {
    var sceneViewController: UIViewController {
        return self.children.last ?? self
    }
}

class SceneCoordinator: SceneCoordinatorType {
    private let bag = DisposeBag()
    
    // SceneCoordinator 는 화면의 전환을 처리하기 때문에 Window 인스턴스와 현재화면에 표시되어있는 Scene을 가지고 있어야 한다.
    private var window: UIWindow
    private var currentVC: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        let subject = PublishSubject<Never>()
        
        let target = scene.instantiate()
        
        switch style {
        case .root:
            currentVC = target.sceneViewController
            window.rootViewController = target
            
            subject.onCompleted()
            
        case .push:
            print(currentVC)
            
            guard let nav = currentVC.navigationController else {
                subject.onError(TranstionError.navigationControllerMissing)
                break
            }
            
            nav.rx.willShow
                .withUnretained(self)
                .subscribe(onNext: { (coordinator, evt) in
                    coordinator.currentVC = evt.viewController.sceneViewController
                })
                .disposed(by: bag)
            
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewController
            
            subject.onCompleted()
            
        case .modal:
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            
            currentVC = target.sceneViewController
        }
        
        return subject.asCompletable()
    }
    
    @discardableResult
    func close(animated: Bool) -> Completable {
        return Completable.create { [unowned self] completable in
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC.sceneViewController
                    completable(.completed)
                }
            }
            
            else if let nav = self.currentVC.navigationController {
                guard nav.popViewController(animated: animated) != nil else {
                    completable(.error(TranstionError.cannotPop))
                    return Disposables.create()
                }
                
                self.currentVC = nav.viewControllers.last!.sceneViewController
                completable(.completed)
            }
            
            else {
                completable(.error(TranstionError.unknown))
            }
            
            return Disposables.create()
        }
    }
}

