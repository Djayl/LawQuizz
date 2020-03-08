//
//  SignUpViewController.swift
//  LawQuizz
//
//  Created by MacBook DS on 04/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import UIKit
import ProgressHUD

@available(iOS 13.0, *)
class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    
    // MARK: - Properties
    
    var myImage: UIImage?
    let authService = AuthService()
    let firestoreService = FirestoreService<Profil>()
    var placeholderLabel = UILabel()
    let schools = ["","Paris 1", "Paris 2", "Paris 3"]
    var school = ""
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.setValue(Colors.clearBlue, forKeyPath: "textColor")
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "SpartanMB-Bold", size: 21)!]
        self.navigationItem.title = "Inscription"
        setupTextFieldsLayer()
        signUpButton.layer.cornerRadius = 5
        setupTextFields()
        setupImageView()
        navigationController?.navigationBar.barTintColor = Colors.smoothBlue
        hideKeyboardWhenTappedAround()
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPhoto)))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
    }

    
    // MARK: - Actions
    
    @IBAction private func signUpAction(_ sender: Any) {
        createUserAccount()
    }
    
    // MARK: - Methods
    
    private func setupTextFieldsLayer() {
       
        userNameTextField.layer.borderWidth = 1
        userNameTextField.layer.borderColor = Colors.smoothBlue.cgColor
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = Colors.smoothBlue.cgColor
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = Colors.smoothBlue.cgColor
        passwordConfirmTextField.layer.borderWidth = 1
        passwordConfirmTextField.layer.borderColor = Colors.smoothBlue.cgColor

        emailTextField.layer.cornerRadius = 5
        passwordTextField.layer.cornerRadius = 5
        passwordConfirmTextField.layer.cornerRadius = 5
        userNameTextField.layer.cornerRadius = 5
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    private func setupImageView() {
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    
    @objc private func addPhoto() {
        showImagePicckerControllerActionSheet()
    }
    
    private func getImage(_ completion: @escaping (String)->Void) {
        guard let image = myImage, let data = image.jpegData(compressionQuality: 1.0) else {
            presentAlert(with: "Il semble y avoir une erreur")
            return
        }
        let firebaseStorageManager = FirebaseStorageManager()
        let imageName = UUID().uuidString
        firebaseStorageManager.uploadImageData(data: data, serverFileName: imageName) { (isSuccess, url) in
            guard let imageUrl = url else {return}
            completion(imageUrl)
        }
    }
    
    private func createUserAccount() {
        guard myImage != nil else {
                
                presentAlert(with: "Merci de choisir une photo de profil")
                return
            }
        guard let userName = userNameTextField.text, userName.isEmptyOrWhitespace() == false else {
           
               presentAlert(with: "Merci de renseigner un nom d'utilisateur")
               return}
           guard let email = emailTextField.text, email.isEmptyOrWhitespace() == false else {
            
               presentAlert(with: "Merci de renseigner un email")
               return}
           guard let password = passwordTextField.text, password.isEmptyOrWhitespace() == false else {
            
               presentAlert(with: "Merci de renseigner un mot de passe")
               return}
           guard let passwordConfirmed = passwordConfirmTextField.text, passwordConfirmed == password, passwordConfirmed.isEmptyOrWhitespace() == false else {
            
               presentAlert(with: "Merci de confirmer votre mot de passe")
               return}
           authService.signUp(email: email, password: password) { (authResult, error) in
               if error == nil && authResult != nil {
                ProgressHUD.show()
                   guard let currentUser = AuthService.getCurrentUser() else { return }
                   self.getImage { (imageURL) in
                    let profil = Profil(identifier: currentUser.uid, email: email, userName: userName, imageURL: imageURL, school: self.school, totalQuestions: 0, goodAnswers: 0, wrongAnswers: 0, rank: 0)
                       self.saveUserData(profil)
                       self.dismiss(animated: true, completion: nil)
                   }
               } else {
                   print("Error creating user: \(error!.localizedDescription)")
                   self.presentAlert(with: error!.localizedDescription)
               }
           }
       }
    
    private func saveUserData(_ profil: Profil) {
        ProgressHUD.showSuccess(NSLocalizedString("Votre compte a été créé", comment: ""))
        firestoreService.saveData(endpoint: .user, identifier: profil.identifier, data: profil.dictionary) { [weak self] result in
            switch result {
            case .success(let successMessage):
                
                print(successMessage)
            case .failure(let error):
                print("Error adding document: \(error)")
                self?.presentAlert(with: "Serveur indisponible")
            }
        }
    }



        
        fileprivate func setupTextFields() {
            
            emailTextField.delegate = self
            passwordTextField.delegate = self
            passwordConfirmTextField.delegate = self
//            schoolTextField.delegate = self
            userNameTextField.delegate = self
            
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Mot de passe",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            passwordConfirmTextField.attributedPlaceholder = NSAttributedString(string: "Confirmer mot de passe",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
//            schoolTextField.attributedPlaceholder = NSAttributedString(string: "École",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            userNameTextField.attributedPlaceholder = NSAttributedString(string: "Nom d'utilisateur",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
    }


    // MARK: - ImagePicker Delegate

    @available(iOS 13.0, *)
    extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        func showImagePicckerControllerActionSheet() {
            let photoLibraryAction = UIAlertAction(title: "Ouvrir la photothèque", style: .default) { (action) in
                self.showImagePickerController(sourceType: .photoLibrary)
            }
            let cameraAction = UIAlertAction(title: "Prendre une photo", style: .default) { (action) in
                self.showImagePickerController(sourceType: .camera)
            }
            let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
            AlertService.showAlert(style: .actionSheet, title: "Choisissez votre image", message: nil, actions: [photoLibraryAction, cameraAction, cancelAction], completion: nil)
        }
        
        private func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = sourceType
            present(imagePickerController, animated: true, completion: nil)
        }
        
        internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                profileImageView.image = editedImage
                myImage = editedImage
            } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                myImage = originalImage
                profileImageView.image = originalImage
            }
            dismiss(animated: true, completion: nil)
        }
    }

@available(iOS 13.0, *)
extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return schools.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return schools[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        school = schools[row]
    }
    
}
