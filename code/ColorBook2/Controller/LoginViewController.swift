//
//  LoginViewController.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 20/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func onClickLogin(_ sender: UIButton) {
    }
    @IBAction func onCancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
