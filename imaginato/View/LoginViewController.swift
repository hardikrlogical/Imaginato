//
//  LoginViewController.swift
//  imaginato
//
//  Created by rlogical-dev-35 on 15/12/20.
//  Copyright © 2020 rlogical-dev-35. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DTTextField
import Closures
class LoginViewController: UIViewController {
    
    //MARK:-  Variable & Outlets Declaration
    private(set) var disposeBag: DisposeBag = DisposeBag()
    private var loginViewModel : LoginViewModel!
    @IBOutlet weak var txtEmail: DTTextField!
    @IBOutlet weak var txtPassword: DTTextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    //MARK:-  View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginViewModel =  LoginViewModel()
        rxvalidation()
        // Do any additional setup after loading the view.
    }
    
    //MARK:-  Validation and and Api call
    func rxvalidation() {
        btnLogin.isEnabled = false
        btnLogin.backgroundColor =  UIColor.lightGray
        let emailValidation: Observable<Bool> = txtEmail.rx.text
            .map { [weak self] text -> Bool in
                guard let isValid = self?.loginViewModel.validateEmail(text: text) else {
                    return false
                }
                
                return isValid
        }
        .share(replay: 1)
        
        let passwordValidation: Observable<Bool> = txtPassword.rx.text
            .map { [weak self] text -> Bool in
                guard let isValid = self?.loginViewModel.validatePassword(text: text) else {
                    return false
                }
                return isValid
        }
        .share(replay: 1)
        
        let everythingValid: Observable<Bool>
            = Observable.combineLatest(
                emailValidation,
                passwordValidation)   { (email: Bool, password: Bool) -> Bool in
                    if !email {
                        if self.txtEmail.text!.count > 0 {
                            self.txtEmail.showError(message: validEmailMessage)
                            self.btnLogin.isEnabled = false
                            self.btnLogin.backgroundColor =  UIColor.lightGray
                        }
                        
                    } else if !password {
                        if self.txtPassword.text!.count > 0 {
                            self.txtPassword.showError(message: validPasswordMessage)
                            self.btnLogin.isEnabled = false
                            self.btnLogin.backgroundColor =  UIColor.lightGray
                        }
                        
                    } else {
                        self.btnLogin.isEnabled = true
                        self.btnLogin.backgroundColor =  UIColor.systemBlue
                        
                    }
                    return email && password
        }
        
        
        everythingValid.bind(to: btnLogin.rx.isEnabled).disposed(by: disposeBag)
        
        //login button tap event with closure
        btnLogin.onTap { [weak self] in
            if self == nil {
                return
            }
            
            guard let email = self?.txtEmail.text, let password = self?.txtPassword.text else {
                return
            }
            self?.loginViewModel.login(email: email, password: password).subscribe { [weak self] event in
                switch event {
                case let .next(message):
                    CustomAlertController.show(message)
                case let .error(error):
                    CustomAlertController.show(error.localizedDescription)
                case .completed:
                    break
                }
            }.disposed(by: self!.disposeBag)
        }
    }
    
}
