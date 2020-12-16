//
//  PhotoViewModel.swift
//  imaginato
//
//  Created by rlogical-dev-35 on 14/12/20.
//  Copyright © 2020 rlogical-dev-35. All rights reserved.

import Foundation
import RxSwift

import Foundation
import RxSwift
import UIKit
import RealmSwift

struct APIError: Error {
    var message: String
}
class LoginViewModel : NSObject {
    
    public func validateEmail(text: String?) -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailTest.evaluate(with: text)
    }
    
    public func validatePassword(text: String?) -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{0,16}")
        return emailTest.evaluate(with: text)
    }
    
    var disposeBag = DisposeBag()
    
    public func login(email: String, password: String) -> Observable<String> {
        return Observable.create { (observer) -> Disposable in
            RESTClient.login(email: email, password: password).request(type: LoginResponse.self).subscribe { event in
                switch event {
                case let .next(resp):
                    if resp.result == 0 {
                        observer.onNext(resp.errorMessage)
                    } else {
                        guard let user = resp.data.user else {
                            return
                        }
                        // Store User to DB
                        do {
                            let realm = try Realm()
                            try realm.write {
                                print(user.userID)
                                print(user.userName)
                                print(user.createdAt)
                                
                                realm.add(user)
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                        observer.onNext("login successful")
                    }
                case let .error(error):
                    print(error.localizedDescription)
                    observer.onNext("Something went wrong, please try again")
                case .completed:
                    break
                }
            }
        }
    }
}
