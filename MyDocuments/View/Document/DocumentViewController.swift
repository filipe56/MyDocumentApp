//
//  DocumentViewController.swift
//  MyDocuments
//
//  Created by Filipe Augusto on 01/09/2018.
//  Copyright © 2018 Filipe Augusto. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let backgroundActivityIndicator = UIView()

    var imagePicker: UIImagePickerController!
    var document: DocumentModel?
    let documentConroller = DocumentController()
    var user: UserModel!
    var photoModel :PhotoModel!
    
    @IBAction func buttonShared(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [photoImageView.image as Any] , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        backgroundActivityIndicator.backgroundColor = UIColor(red: 16.0/255, green: 13/255.0, blue: 45.0/255, alpha: 0.5)
        backgroundActivityIndicator.frame = UIScreen.main.bounds
        self.view.addSubview(backgroundActivityIndicator)
        backgroundActivityIndicator.isHidden = true

        // Set up views if editing an existing Document.
        if let document = document {
            activeActivityIndicator()
            backgroundActivityIndicator.isHidden = false

            navigationItem.title = document.nome
            nameTextField.text = document.nome
            if let photoId = document.photoId {
                documentConroller.selectPhoto(idPhoto: photoId) { result in
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.backgroundActivityIndicator.isHidden = true
                    if result != nil {
                        let photoDocument = result as! PhotoModel
                        self.photoModel = photoDocument
                        if let imgData = Data(base64Encoded: photoDocument.img!), let img = UIImage(data: imgData) {
                            self.photoImageView.image = img
                        }
                    } else {
                        self.photoImageView.image = UIImage(named: "defaultPhoto")
                    }
                }
            }
        }
        
        
        // Enable the Save button only if the text field has a valid Document name.
        updateSaveButtonState()
    }
    
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        if textField.text == "" {
            saveButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.image = chosenImage
        dismiss(animated:true, completion: nil) 
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddDocumentMode = presentingViewController is UINavigationController
        
        if isPresentingInAddDocumentMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The DocumentViewController is not inside a navigation controller.")
        }
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func registerDocument(_ sender: UIBarButtonItem) {
        self.activeActivityIndicator()
        self.backgroundActivityIndicator.isHidden = false


        var dataPhoto = Data()
        let name = nameTextField.text ?? ""
        if let photo = photoImageView.image {
            dataPhoto = UIImagePNGRepresentation(photo)!
        }
        
        var alert = UIAlertController()
        var idPhoto: Int?
        if let photo = self.photoModel, let id = photo.id {
            idPhoto = id
        }
        documentConroller.saveDocument(name: name, photo: dataPhoto, id: document?.id, idUser: self.user.id!, idPhoto: idPhoto) { result in
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.backgroundActivityIndicator.isHidden = true
            if result as! Bool {
                alert = UIAlertController(title: "", message: "Documento salvo com sucesso", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
                    self.navigationController?.popViewController(animated: true)
                }))
            } else {
                alert = UIAlertController(title: "Erro", message: "O Documento não foi salvo com sucesso", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
                }))
            }
            self.present(alert, animated: true)
            }
        
    }
    
    //Activity Indicator
    func activeActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}

