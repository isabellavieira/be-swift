//
//  User.swift
//  be-swift
//
//  Created by Isabella Vieira on 08/10/17.
//  Copyright © 2017 Isabella Vieira. All rights reserved.
//
import Foundation


class User {
    
    // MARK: Attributes
    var name: String?
    var email: String?
    var password: String?
    var xpTotal: Int?
    var starTotal: Int?
    
    // MARK: DAO instance
    var userDAO: UserDAO = UserDAO.sharedInstance
    
    // MARK: Singleton
    static let sharedInstance = User()
    
    init(){}
    
    //MARK: Methods
//    func login(email: String, password: String) {
//        userDAO.loadUser(email: email, password: password)
//    }
    
    func checkLogedIn() -> Bool {
        if UserDAO.sharedInstance.checkLoadedUser() {
            print("PessoaInterf - usuario ja logado")
            return true
        }
        return false
    }
    
    func logout () {
        userDAO.logout()
        self.name = ""
        self.email = ""
        self.password = ""
        self.xpTotal = 0
        self.starTotal = 0
    }
    
//    func register (handler: self, email: String, password: String) {
//        userDAO.registerUser(handler: self, email: email, password: password)
//    }
//    
//    func saveRegistration (name: String, email: String, password: String, country: String, major: String) {
//        userDAO.saveRegistration(name: name, email: email, password: password, country: country, major: major)
//    }


}
