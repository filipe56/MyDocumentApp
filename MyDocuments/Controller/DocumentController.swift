//
//  DocumentController.swift
//  MyDocuments
//
//  Created by Filipe Augusto on 01/09/2018.
//  Copyright © 2018 Filipe Augusto. All rights reserved.
//

import Foundation

class DocumentController: NSObject {
    
    var listDocuments = [DocumentModel]()
    
    
    func loadDocuments(idUser: Int, callback: @escaping HandlerObject) {
        ServiceDocument().loadDocument(idUser: idUser) { (result) in
            self.listDocuments = result as! [DocumentModel]
            callback(self.filterListDocuments(name: "", documents: self.listDocuments))
        }
    }
    
    func saveDocument(name: String, photo: Data, id: Int?, idUser: Int, idPhoto: Int? ,callback: @escaping HandlerObject){
        let objPhoto = PhotoModel()
        objPhoto.img = encodeImageToBase64(imageData: photo)
        if let idPhoto = idPhoto {
            objPhoto.id = idPhoto
        }
        
        
        if id != nil {
            ServiceDocument().updatePhoto(photo: objPhoto) { result in
                if result as! Bool {
                    
                    let objDocument = DocumentModel.init()
                    objDocument.id = id
                    objDocument.nome = name
                    objDocument.photoId = result as? Int
                    objDocument.userId = idUser
                    objDocument.data = "\(Date().timeIntervalSinceNow)"
                    objDocument.updatedAt = "\(Date().timeIntervalSinceNow)"
                    objDocument.createdAt = "\(Date().timeIntervalSinceNow)"
                    ServiceDocument().updateDocument(document: objDocument) { result in
                        if result != nil{
                            self.listDocuments.append(result as! DocumentModel)
                            callback(true)
                        } else {
                            callback(false)
                        }
                    }
                }
            }
        } else {
            ServiceDocument().addPhoto(photo: objPhoto) { result in
                if result as! Int > 0 {
                    
                    let objDocument = DocumentModel.init()
                    objDocument.nome = name
                    objDocument.photoId = result as? Int
                    objDocument.userId = idUser
                    objDocument.data = "\(Date().timeIntervalSinceNow)"
                    objDocument.updatedAt = "\(Date().timeIntervalSinceNow)"
                    objDocument.createdAt = "\(Date().timeIntervalSinceNow)"
                    ServiceDocument().addDocument(document: objDocument) { result in
                        if result != nil{
                            self.listDocuments.append(result as! DocumentModel)
                            callback(true)
                        } else {
                            callback(false)
                        }
                    }
                }
            }
        }
    }
    
    func encodeImageToBase64(imageData : Data) -> String{
        let strBase64 = imageData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        return strBase64
    }
    
    func deleteDocument(i: Int, callback: @escaping HandlerObject){
        ServiceDocument().deleteDocument(document:self.listDocuments[i]) { result in
            if result as! Bool {
                self.listDocuments.remove(at: i)
                callback(true)
            } else {
                callback(false)
            }
        }
    }
    
    
    func filterListDocuments(name: String, documents: [DocumentModel]) -> [DocumentModel] {
        if name.isEmpty {
            return self.listDocuments
        }
        
        return documents.filter{$0.nome?.lowercased().contains(name.lowercased()) ?? false}
    }
    
    
    func selectDocument(i: Int) -> DocumentModel {
        return self.listDocuments[i]
    }
    
    func selectPhoto(idPhoto: Int, callback: @escaping HandlerObject) {
        ServiceDocument().loadPhoto(idPhoto: idPhoto) { result in
            if result !=  nil{
                callback(result)
            } else {
                callback(nil)
            }
        }
    }
    
    
    func orderListDocuments(documents: [DocumentModel]) -> [DocumentModel]{
        return documents.sorted { $0.nome! < $1.nome! }
    }
    
}
