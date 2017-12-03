//
//  RegisterViewController.swift
//  be-swift
//
//  Created by Isabella Vieira on 22/11/17.
//  Copyright © 2017 Isabella Vieira. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RegisterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UserHandler, UITextFieldDelegate  {

    var countryList: Array<String>!
    var courseList: Array<String>!
    var indicator = UIActivityIndicatorView()
    var registerView: RegisterView!
    var user = User()
    var userDAO = UserDAO()
    var success: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ("CONTROLLER - selector")
        registerView = RegisterView(goBack: #selector(goBack), signUp: #selector(checkInfo))
        
        //Delegate and data source pickerViews
        self.registerView.pickerCountry.dataSource = self
        self.registerView.pickerCourse.dataSource = self
        self.registerView.pickerCountry.delegate = self
        self.registerView.pickerCourse.delegate = self
        //Delegate textFields
        self.registerView.nameText.delegate = self
        self.registerView.emailText.delegate = self
        self.registerView.passwordText.delegate = self
        self.registerView.passwordConfirmationText.delegate = self
        self.registerView.countryText.delegate = self
        self.registerView.courseText.delegate = self
        
        countryList = ["Brazil", "United States of America", "Canada"]
        courseList = ["Business Administration","Computer Science", "Design", "Engineering", "Law"]
        
        self.view.addSubview(registerView)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        DispatchQueue.main.async {
            self.view.addSubview(self.indicator)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numberOfRows = 0
        
        if pickerView == self.registerView.pickerCountry {
            numberOfRows = self.countryList.count
        }
        else if pickerView == self.registerView.pickerCourse {
            numberOfRows = self.courseList.count
        }
        return numberOfRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var listItem = ""
        
        if pickerView == self.registerView.pickerCountry {
            listItem = self.countryList[row]
        } else if pickerView == self.registerView.pickerCourse {
            listItem = self.courseList[row]
        }
        return listItem
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.registerView.pickerCountry {
            self.registerView.countryText.text = self.countryList[row]
            self.registerView.countryText.endEditing(true)
        } else if pickerView == self.registerView.pickerCourse {
            self.registerView.courseText.text = self.courseList[row]
            self.registerView.courseText.endEditing(true)
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    // Botao de confirmar cadastro
    @objc func checkInfo() {
        print ("ENTROU CHECK INFO")
        let nameTxt = self.registerView.nameText.text
        let emailTxt = self.registerView.emailText.text?.lowercased()
        let passwordTxt = self.registerView.passwordText.text
        let passwordCheckTxt = self.registerView.passwordConfirmationText.text
        let countryTxt = self.registerView.countryText.text
        let courseTxt = self.registerView.courseText.text
        
        print ("CONTROLLER - CHECKING DATA")
        //Verificações para cadastro
        if nameTxt == "" || emailTxt == "" || passwordTxt == "" || passwordCheckTxt == "" {
            showAlert(title: "Ops!", message: "Please inform your e-mail and choose a password.")
            return
        } else if (passwordTxt?.count)! < 6 {
            showAlert(title: "Ops!", message: "Your password should be at least 6 characters long.")
            return
        } else if passwordTxt != passwordCheckTxt {
            showAlert(title: "Ops!", message: "The passwords you typed don't match.")
            return
        } else if isValidEmail(testStr: emailTxt!) == false {
            showAlert(title: "Ops!", message: "Please type a valid e-mail address.")
            return
        } else {
            //Firebase - create user
            print ("CONTROLLER - REGISTER")
            userDAO.registerUser(handler: self, email: emailTxt!, password: passwordTxt!)
            
            // salva no banco os dados do formulario
            print ("CONTROLLER - SAVE DATABASE")
            userDAO.saveRegistration(name: nameTxt!, email: emailTxt!, password: passwordTxt!, country: countryTxt!, major: courseTxt!)
        }
    }
    
    func loginUser(success: Bool) {
        self.success = success
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
        
        if (self.success == true) {
            print("You have successfully registered")
            showAlert(title: "Welcome!", message: "Your account was successfully created!")
            
            //Define novo rootViewController e redireciona ao controller dos challenges
            let viewController = ViewController()
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let window = delegate.window
            window?.rootViewController = viewController
            self.present(viewController, animated: true, completion: nil)
            
        } else if (success == false) {
            print("registro falhooou")
            let alert = UIAlertController(title: "Registration Failed!", message: "The email address is already in use by another account", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: title, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){

        let heightiPhoneSE: CGFloat = 568
        let screenSize = UIScreen.main.bounds
        let yScale = screenSize.height/heightiPhoneSE

        if textField.frame.origin.y + textField.frame.height + 20*yScale > 318*yScale {
            self.registerView.frame.origin.y -= (self.registerView.pickerCountry.frame.height - self.registerView.signUpButton.frame.height - 16*yScale)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField){
        self.registerView.frame.origin.y = 0
    }

    @objc func goBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
