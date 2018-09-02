//
//  ServiceDocument.swift
//  MyDocuments
//
//  Created by Filipe Augusto on 01/09/2018.
//  Copyright © 2018 Filipe Augusto. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct ServiceConstant {
    static let rootDefault = "https://mydocuments.herokuapp.com"
    static let rootDocuments = rootDefault + "/documents"
    static let rootPhotos = rootDefault + "/photos"
}

/// Service Document
class ServiceDocument: NSObject {
    
    /// CREAT PHOTO
    ///
    /// - Parameters:
    ///   - document: adding photo
    ///   - callback: A function callback on request is completed, returning the status of request
    func addPhoto(photo: PhotoModel?, callback: @escaping HandlerObject) {
        if let objPhoto = photo {
            var photoObjeto: PhotoModel?
            Alamofire.request(ServiceConstant.rootPhotos, method: .post, parameters: objPhoto.dictionaryRepresentation(), encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
                if response.error == nil {
                    if let json = response.result.value {
                        photoObjeto = PhotoModel.init(object: json)
                    } else {
                        print("ERROR SERVICE USER -----------------------------")
                        print(response.description)
                        callback(nil)
                    }
                    
                    callback(photoObjeto?.id)
                } else {
                    callback(0)
                }
            })
        }
    }
    
    /// CREAT DOCUMENT
    ///
    /// - Parameters:
    ///   - document: adding document
    ///   - callback: A function callback on request is completed, returning the status of request
    func addDocument(document: DocumentModel?, callback: @escaping HandlerObject) {
        if let objDocument = document {
            Alamofire.request(ServiceConstant.rootDocuments, method: .post, parameters: objDocument.dictionaryRepresentation(), encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
                print(response.response as Any)

                if response.error == nil {
                    if let json = response.result.value {
                    callback(DocumentModel.init(object: json))
                    }
                } else {
                    callback(nil)
                    print("ERROR SERVICE USER -----------------------------")
                    print(response.description)
                }
                
            })
        }
    }
    
    /// READ DOCUMENT
    ///
    /// - Parameter callback: A function callback on request is completed,
    ///   returning the status of request
    public func loadDocument(idUser : Int, callback: @escaping HandlerObject) {
        var repostitoryDocument = [DocumentModel]()
        
        Alamofire.request(ServiceConstant.rootDocuments).responseJSON { response in
            print(response.result)
            if let json = response.result.value as? [AnyObject]{
                for document in json {
                    let documentRepostitory = DocumentModel(json:JSON(document))
                    if documentRepostitory.userId == idUser {
                        repostitoryDocument.append(documentRepostitory)
                    }
                }
                callback(repostitoryDocument)
            } else {
                print("ERROR SERVICE USER -----------------------------")
                print(response.description)
                callback(nil)
            }
        }
    }
    
    /// READ PHOTO
    ///
    /// - Parameter callback: A function callback on request is completed,
    ///   returning the status of request
    public func loadPhoto(idPhoto: Int, callback: @escaping HandlerObject) {
        let delUrl = ServiceConstant.rootPhotos + "/" + "\(idPhoto)"
        Alamofire.request(delUrl).responseJSON { response in
            print(response.result)
            if let json = response.result.value {
                    let photoRepostitory = PhotoModel(json: JSON(json))
                    callback(photoRepostitory)
            } else {
                print("ERROR SERVICE USER -----------------------------")
                print(response.description)
                callback(nil)
            }
        }
    }
    
    /// DELETE DOCUMENT
    ///
    /// - Parameters:
    ///   - document: document to delete
    ///   - callback: A function callback on request is completed, returning the status of request
    func deleteDocument (document: DocumentModel?, callback: @escaping HandlerObject) {
        var delUrl = ""
        if let idDocument = document?.id {
            delUrl = ServiceConstant.rootDocuments + "/" + "\(idDocument)"
        }
        let idPhoto = document?.photoId
        if let objDocument = document {
            Alamofire.request(delUrl, method: .delete, parameters:
                objDocument.dictionaryRepresentation(), encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
                    print(response.response as Any)
                    
                    if response.error == nil {
                        self.deleteImage(idImage: idPhoto, callback: { success in
                            if success as! Bool {
                                callback(true)
                            } else {
                                callback(false)
                                print("ERROR SERVICE USER -----------------------------")
                                print(response.description)
                            }
                        })
                    } else {
                        callback(false)
                    }
                })
        }
        
    }
    
    /// DELETE PHOTO
    ///
    /// - Parameters:
    ///   - document: Image to delete
    ///   - callback: A function callback on request is completed, returning the status of request
    func deleteImage(idImage: Int?, callback: @escaping HandlerObject) {
        
        let delUrl = ServiceConstant.rootPhotos + "/" + "\(idImage!)"
        let objPhoto = PhotoModel()
        objPhoto.id = idImage
        if idImage != nil {
            Alamofire.request(delUrl, method: .delete, parameters:
                objPhoto.dictionaryRepresentation(), encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
                    print(response.response as Any)
                    if response.error == nil {
                        callback(true)
                    } else {
                        callback(false)
                        print("ERROR SERVICE USER -----------------------------")
                        print(response.description)
                    }
                })
            
        }
    }
    
    /// UPDATE DOCUMENT
    ///
    /// - Parameters:
    ///   - document: document to update
    ///   - callback: A function callback on request is completed, returning the status of request
    func updateDocument(document: DocumentModel?, callback: @escaping HandlerObject) {
        if let objDocument = document {
            var updateUrl = ""
            if let idDocument = document?.id {
                updateUrl = ServiceConstant.rootDocuments + "/" + "\(idDocument)"
            }
            Alamofire.request(updateUrl, method: .put, parameters:
                objDocument.dictionaryRepresentation(), encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
                    if response.error == nil {
                        if let json = response.result.value {
                            callback(DocumentModel.init(object: json))
                        }
                    } else {
                        callback(nil)
                        print("ERROR SERVICE USER -----------------------------")
                        print(response.description)
                    }
                })
        }
    }
    
    /// UPDATE PHOTO
    ///
    /// - Parameters:
    ///   - document: photo to update
    ///   - callback: A function callback on request is completed, returning the status of request
    func updatePhoto(photo: PhotoModel?, callback: @escaping HandlerObject) {
        if let objPhoto = photo {
            var updateUrl = ""
            if let idPhoto = photo?.id{
                updateUrl = ServiceConstant.rootDocuments + "/" + "\(idPhoto)"
            }
            Alamofire.request(updateUrl, method: .put, parameters:
                objPhoto.dictionaryRepresentation(), encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
                    if response.error == nil {
                        callback(true)
                    } else {
                        callback(false)
                        print("ERROR SERVICE USER -----------------------------")
                        print(response.description)
                    }
            })
        }
    }
    
    
    
}
