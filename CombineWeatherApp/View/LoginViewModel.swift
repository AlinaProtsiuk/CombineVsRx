//
//  LoginViewModel.swift
//  CombineWeatherApp
//
//  Created by Alina Protsiuk on 17.02.2020.
//  Copyright © 2020 CoreValue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    var userLogin = BehaviorRelay<String>(value: "")
    var userPassword = BehaviorRelay<String>(value: "")
    var canShowLoginButton = PublishSubject<Bool>()
    var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        Observable.combineLatest(userLogin.asObservable(), userPassword.asObservable()) { login, password in
            return !login.isEmpty && !password.isEmpty && password.count >= 12
            
        }.subscribe(onNext: { [weak self] (result) in
            self?.canShowLoginButton.onNext(result)
            }).disposed(by: disposeBag)
    }
    
}
