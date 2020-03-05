//
//  LoginViewController.swift
//  LawQuizz
//
//  Created by MacBook DS on 04/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import UIKit


@available(iOS 13.0, *)
final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        navigationController?.navigationBar.barTintColor = UIColor.white
        setupTextFields()
        loginButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction private func loginAction(_ sender: Any) {
        logIn()
        
    }
    
    @IBAction private func resetPassword() {
        guard let email = emailTextField.text, emailTextField.text?.isEmpty == false else {
//            presentAlert(with: "Il vous faut renseigner une addresse email")
            return
        }
        let authService = AuthService()
        authService.resetPassword(email: email) { [weak self] authDataResult, error in
            if error == nil && authDataResult != nil {
                self?.showSimpleAlert(message: "Un mail vient de vous être transmis")
                print("password send")
            } else {
                print("thers is an error")
                self?.presentAlert(with: error?.localizedDescription ?? "Erreur réseau")
            }
        }
    }
    
    @IBAction private func noAccount(_ sender: Any) {
        performSegue(withIdentifier: "goToSignUp", sender: self)
    }
    
    // MARK: - Methods
    
    private func setupTextFields() {
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.systemBlue.cgColor
        emailTextField.layer.cornerRadius = 5
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.systemBlue.cgColor
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Mot de passe",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    
    private func logIn() {
           guard let email = emailTextField.text, !email.isEmpty else {
               
               presentAlert(with: "Merci d'entrer une adresse mail")
               return
           }
           guard let password = passwordTextField.text, !password.isEmpty else {
            
               presentAlert(with: "Merci d'entrer un mot de passe")
               return
           }
           
           let authService = AuthService()
           authService.signIn(email: email, password: password) { [weak self] authDataResult, error in
               if error == nil && authDataResult != nil {
//                    NotificationCenter.default.post(name: Notification.Name("showSpots"), object: nil)
                   self?.dismiss(animated: true, completion: nil)
               } else {
                   print("Error loging user: \(error!.localizedDescription)")
                self?.presentAlert(with: error?.localizedDescription ?? "Erreur réseau")
               }
           }
       }
}

// MARK: - UITextfield Delegate

@available(iOS 13.0, *)
extension LoginViewController: UITextFieldDelegate {
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


