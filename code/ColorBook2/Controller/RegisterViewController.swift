//
//  RegisterViewController.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 20/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import UIKit
import Alamofire
protocol RegisterViewControllerDelegate {
    func loginDidSuccess(registerViewController: RegisterViewController, username: String)
}
class RegisterViewController: UIViewController {

    // MARK: - outlet property
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPwTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - outlet functions
    @IBAction func onUsernameDidEntered(_ sender: UITextField) {
        registerButton.isEnabled = checkAllEntered()
    }
    
    @IBAction func onPasswordDidEntered(_ sender: UITextField) {
        registerButton.isEnabled = checkAllEntered()
    }
    
    @IBAction func onConfirmPasswordDidEntered(_ sender: UITextField) {
        registerButton.isEnabled = checkAllEntered()
    }
    
    @IBAction func onEmailDidEntered(_ sender: UITextField) {
        registerButton.isEnabled = checkAllEntered()
    }
    
    @IBAction func onClickRegister(_ sender: UIButton) {
        var response = isValidateEmail(inputText: emailTextField.text!)
        if response.isSuccess() {
            response = isValidatePassword()
            if response.isSuccess() {
                let form = [
                    "username" : userNameTextField.text!,
                    "email" : emailTextField.text!,
                    "password": Encryption.MD5(string: passwordTextField.text!)
                ]
                
                Alamofire.request("http://139.196.94.117:10000/user/register", method: .post, parameters: form, encoding: JSONEncoding.default).responseString(completionHandler: {
                    response in
                    print(response.result.value ?? "")
                    print(response.response?.statusCode ?? "")
                    if response.response?.statusCode == 200 {
                        // auto login
                        Global.login = true
                        Global.username = self.userNameTextField.text
                        Global.userEmail = self.emailTextField.text
                        self.delegate?.loginDidSuccess(registerViewController: self, username: self.userNameTextField.text!)
                        
                        self.messageLabel.isHidden = true
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.messageLabel.text = response.result.value ?? ""
                        self.messageLabel.sizeToFit()
                        self.messageLabel.isHidden = false
                    }
                })
            }
        }
        messageLabel.text = response.message
        messageLabel.isHidden = false
        messageLabel.sizeToFit()

    }
    @IBAction func onCancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - none-outlet property
    var delegate: RegisterViewControllerDelegate?
    
    // MARK: - none-outlet functions
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.isEnabled = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkAllEntered() -> Bool {
        
        if let text = passwordTextField.text {
            if text.count != 0 {
                if let cpw = confirmPwTextField.text {
                    if cpw.count != 0 {
                        if let email = emailTextField.text {
                            if email.count != 0 {
                                if let username = userNameTextField.text {
                                    if username.count != 0 {
                                        return true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
    func isValidateEmail(inputText: String) -> Response {
        print("validate emilId: \(inputText)")
        let stricterFilter = true
        let stricterFilterString = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let laxString = ".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
        let emailRegex = stricterFilter ? stricterFilterString : laxString
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if emailTest.evaluate(with: inputText) {
            return Response.createBySuccess()
        } else {
            return Response.createByError(message: "Invalid email")
        }
    }
    
    func isValidatePassword() -> Response {
        if let text = passwordTextField.text {
            if text.count < 6 {
                return  Response.createByError(message: "The password should be more than 6 digits")
            } else {
                if let confirmText = confirmPwTextField.text {
                    if confirmText == text {
                        return Response.createBySuccess()
                    } else {
                        return Response.createByError(message: "Password is inconsistent")
                    }
                } else {
                    return Response.createByError(message: "Confirm password not entered")
                }
            }
        }
        return  Response.createByError(message: "Password not entered")
    }

}
