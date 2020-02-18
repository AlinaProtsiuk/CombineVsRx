//
//  LoginViewController.swift
//  CombineWeatherApp
//
//  Created by Alina Protsiuk on 14.02.2020.
//  Copyright © 2020 CoreValue. All rights reserved.
//

import UIKit
import Combine
import RxSwift

extension Notification.Name {
    static let userName = Notification.Name("user-name")
}

class LoginViewController: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private var buttonSubscriber: AnyCancellable?
    private var loginSubscriber: AnyCancellable?
    private var passwordSubscriber: AnyCancellable?
    private var validatedCredentials: AnyCancellable?
    private var loginBtnSubscriber: AnyCancellable?
    private var postNotificPublisher: AnyCancellable?
    
    let usernamePublisher = PassthroughSubject<String, Never>()
    let passwordPublisher = PassthroughSubject<String, Never>()
    
    @Published var showLoginButton = true
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        buttonSubscriber = $showLoginButton
//            .print("buttonSubscriber")
//            .assign(to: \.isHidden, on: loginButton)
//
//        validatedCredentials = Publishers.CombineLatest(usernamePublisher, passwordPublisher)
//            .map { (username, password) -> Bool in
//                !username.isEmpty && !password.isEmpty && password.count >= 12
//        }
//        .replaceError(with: false)
//        .sink { [weak self] (valid) in
//            self?.showLoginButton = !valid
//        }
//
//        loginSubscriber = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: loginTextField)
//            .map({($0.object as? UITextField)?.text ?? ""})
//            .receive(on: RunLoop.main)
//            .sink { [weak self] (value) in
//                self?.usernamePublisher.send(value)
//                self?.passwordPublisher.send(self?.passwordTextField.text ?? "")
//        }
//
//        passwordSubscriber = NotificationCenter.Publisher(center: .default, name: UITextField.textDidChangeNotification, object: passwordTextField)
//            .map { ($0.object as? UITextField)?.text ?? ""}
//            .print("Init")
//            .receive(on: RunLoop.main)
//            .sink(receiveCompletion: { (completion) in
//                switch completion {
//                case .finished:
//                    break
//                case .failure:
//                    print("Fail")
//                }
//            }) { [weak self] (value) in
//                self?.usernamePublisher.send(self?.loginTextField.text ?? "")
//                self?.passwordPublisher.send(value)
//        }
//
//        loginBtnSubscriber = loginButton
//            .publisher(for: .touchUpInside)
//            .sink { [weak self] (button) in
//                _ = NotificationCenter.Publisher(center: .default, name: .userName, object: self?.loginTextField)
//                .print("Name")
//                .map({ ($0.object as! UITextField).text ?? ""})
//
//                self?.performSegue(withIdentifier: "showWheatherScreen", sender: nil)
//        }
        
        loginTextField.rx.text
            .map({$0 ?? ""})
            .bind(to: viewModel.userLogin)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .map({ $0 ?? ""})
            .bind(to: viewModel.userPassword)
            .disposed(by: disposeBag)
        
        viewModel.canShowLoginButton
            .subscribe(onNext: { [weak self] (result) in
                self?.loginButton.isHidden = !result
            }).disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe { [weak self] (_) in
            self?.performSegue(withIdentifier: "showWheatherScreen", sender: nil)
        }
        .disposed(by: disposeBag)
    }
}
