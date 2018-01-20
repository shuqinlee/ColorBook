//
//  RegisterViewController.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 20/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import UIKit
//import 
class RegisterViewController: UIViewController {

    // MARK: - outlet property
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPwTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
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
        
    }
    @IBAction func onCancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - none-outlet property
    
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
