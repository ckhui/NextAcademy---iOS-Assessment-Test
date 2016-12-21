//
//  AppAction.swift
//  iosFinal
//
//  Created by NEXTAcademy on 12/21/16.
//  Copyright © 2016 ckhui. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class AppAction {

    var frDBref: FIRDatabaseReference!
    init(){
        frDBref = FIRDatabase.database().reference()
    }
    
    func currentUserUid() -> String {
        guard let user = FIRAuth.auth()?.currentUser
            else{
                return ""
        }
        return user.uid
    }
    
    func changeProfilePicture(with image : UIImage) {
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
            UIViewController().warningPopUp(withTitle: "Image Type Error", withMessage: "Image Type Error")
            return
        }
        
        let newMetadata = FIRStorageMetadata()
        newMetadata.contentType = "image/jpeg"
        
        let path = "/ProfilePicture/\(currentUserUid()).jpg"

        //upload image
        let frStorage = FIRStorage.storage().reference()
        frStorage.child(path).put(imageData, metadata: newMetadata, completion: {
            (storageMeta, error) in
            if let uploadError = error
            {
                UIViewController().warningPopUp(withTitle: "Upload Photo Error", withMessage: "\(uploadError)")
            }
            else {
                let downloadURL = storageMeta!.downloadURL()?.absoluteString
                let userUid = self.currentUserUid()
                
                let dbPath = "User/\(userUid)/"
                self.modifyDatabase(path: dbPath, key: "picUrl", value: downloadURL!)
            }
        })
    }

    func modifyDatabase(path: String,dictionary : [String : String] , autoId : Bool = false){
        if autoId{
            frDBref.child("\(path)/").childByAutoId().setValue(dictionary)
        }
        else{
            frDBref.child("\(path)/").setValue(dictionary)
        }
    }
    
    func modifyDatabase(path: String,key: String,value: String){
        frDBref.child("\(path)/\(key)").setValue(value)
    }
    
    func deleteFromDatabase(path: String, item : String){
        frDBref.child("\(path)/").child(item).removeValue()
    }
    
    func prepareProfileDictionary(name : String, age : Int,  gender : genderType, desc : String) -> [String : String]{
        var dict = [String : String]()
        dict["name"] = name
        dict["age"] = String(age)
        dict["desc"] = desc
        
        var tempGender = ""
        switch gender {
        case .male:
            tempGender = "m"
            break
        case .female:
            tempGender = "f"
            break
        default:
            tempGender = "u"
        }
        
        dict["gender"] = tempGender
        
        return dict
    }
    
    
    enum actionType {
        case match
        case unmatch
        case updateProfileInfo
    }
    
    func perform(actionWithType type : actionType, targetUid : String?, dict : [String : String] = [:]) {
        
        let userUid = self.currentUserUid()
        var path = ""
        
        switch type {
        case .match:
            guard let target = targetUid
                else {
                    break
            }
            path = "Match/\(userUid)/"
            self.modifyDatabase(path: path, key: target, value: "true")
            break
            
        case .unmatch:
            guard let target = targetUid
                else {
                    break
            }
            path = "Match/\(userUid)/"
            self.deleteFromDatabase(path: path, item: target)
            break
            
            
        case .updateProfileInfo:
            path = "User/\(userUid)/info/"
            self.modifyDatabase(path: path, dictionary: dict)
            break
        }
    }
    
}



extension UIViewController{
    func warningPopUp(withTitle title : String?, withMessage message : String?){
        let popUP = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        popUP.addAction(okButton)
        present(popUP, animated: true, completion: nil)
    }
}

var imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        self.image = nil
    
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            })
        }).resume()
    }
}
