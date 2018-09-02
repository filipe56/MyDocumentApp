//
//  NewUserViewController.swift
//  MyDocuments
//
//  Created by Filipe Augusto on 01/09/2018.
//  Copyright © 2018 Filipe Augusto. All rights reserved.
//

import UIKit
import JMMaskTextField_Swift

class NewUserViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textTelefone: UITextField!
    @IBOutlet weak var buttonAddUser: UIButton!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        textName.delegate = self
        textEmail.delegate = self
        textTelefone.delegate = self
        let maskTextField = JMMaskTextField(frame: CGRect.zero)
        maskTextField.maskString = "(00) 0 0000-0000"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Navigation
    @IBAction func register(_ sender: UIButton) {
        if let name = textName.text, let email = textEmail.text {
            activeActivityIndicator()
            var title = ""
            var message = "Atenção"
            let userSaveSuccess = UserController().saveUser(userName: name, userEmail: email, userPhone: textTelefone.text)
            if name.isEmpty, email.isEmpty {
                message = "Você precisa preencher os campos de nome e email"
            } else {
                message = "Usuário não foi salvo com sucesso"
                if userSaveSuccess  {
                    title = ""
                    message = "Usuário salvo com sucesso"
                }
            }
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            

            if userSaveSuccess {
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(okAction)
            }
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == textTelefone {
       
            guard let text = textField.text as NSString? else { return true }
            let newText = text.replacingCharacters(in: range, with: string)
            
            let maskTextField = textField as! JMMaskTextField
            guard let unmaskedText = maskTextField.stringMask?.unmask(string: newText) else { return true }
            
            if unmaskedText.count >= 11 {
                maskTextField.maskString = "(00) 0 0000-0000"
            } else {
                maskTextField.maskString = "(00) 0000-0000"
            }
        }
        return true
    }
    
    
    //Activity Indicator
    func activeActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
}
