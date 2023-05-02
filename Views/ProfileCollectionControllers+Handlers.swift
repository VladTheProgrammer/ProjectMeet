/*
 ProfileCollectionControllers+Handlers.swift
 project18

 Created by Vladimir Kisselev on 2018-02-20.
 Copyright © 2018 Matias Jow. All rights reserved.
 
 This class is an extension of the ProfileCollectionView. Contains handler methods for downloading pictures to storagebase
 from a Facebook URL, creating a storage reference from a URL, uploading current references to a local array,
 consolidate storage base with the new array of images, and consolidate database with new image references.
*/
 
import UIKit
import Firebase
import FirebaseStorage
import FirebaseStorageUI

/*
 Extending support class for ProfileCollectionView.
 */
extension ProfileCollectionView{
    
    /*
     Method used to handle a download of an image from the Facebook image URL string.
     Stores to a temporary UIimage variable to pass to the handleImageUpload method.
     */
    func handleUrlToDownload(sourceUrl: String){
        
        //Testing
        //print(sourceUrl)
        
        //Session setup
        let session = URLSession(configuration: .default)
        
        let imageUrl = URL(string: sourceUrl)
        
        //Creating a data task to pull image from Facebook URL
        let getImageFromUrl = session.dataTask(with: imageUrl!) {
            (data, response, error) in
            
            if let e = error {
                
                print("Error Occured: \(e)")
            } else {
                
                //in case of now error, checking wheather the response is nil or not
                if (response as? HTTPURLResponse) != nil {
                    
                    //checking if the response contains an image
                    if let imageData = data {
                        
                        //getting the image
                        if let image = UIImage(data: imageData){
                            
                            print("Successful pull")
                            
                            //Passing image to the Upload method
                            self.handleImageUpload(image: image, originalLocation: imageUrl!, completionHandler: {
                                DispatchQueue.main.async {
                                    
                                    self.pictureCollection.reloadData()
                                }
                            })
                        }
                    } else {
                        
                        print("Image file is currupted")
                    }
                } else {
                    
                    print("No response from server")
                }
            }
        }
        
        //Starting task
        getImageFromUrl.resume()
    }
    
    /*
     Method used to handle upload to storagebase from a UIImage.
     */
    func handleImageUpload(image: UIImage, originalLocation: URL, completionHandler: @escaping () -> ()){
        
        //Creating Image reference to the storagebase location from URL
        let storageRef = Storage.storage().reference()
        let imageFolderRef = storageRef.child(CurrentUser.sharedInstance.userID)
        let finalLocation = String(originalLocation.hashValue)
        let imageNameRef = imageFolderRef.child(finalLocation)
        
        let resizedImage = image.resizeWithWidth(width: 300)
        
        //Representing image as a PNGRepresentation
        if let uploadData = UIImagePNGRepresentation(resizedImage!){
            
            //Uploading to storagebase
            imageNameRef.putData(uploadData, metadata: nil, completion: {(metadata, error) in
                
                if error != nil {
                    
                    print("Error occured on upload: \(String(describing: error))")
                    return
                }
                completionHandler()
            })
        }
    }
    
    
    /*
     Method to handle the creation of a StorageReference object from an image URL.
     Returns StorageReference: imageNameRef
     */
    func handleImageReferencing(imgUrl: URL) -> StorageReference{
 
        let storageRef = Storage.storage().reference()
        let imageFolderRef = storageRef.child(CurrentUser.sharedInstance.userID)
        let imageNameRef = imageFolderRef.child(String(imgUrl.hashValue))
        
        return imageNameRef
    }
    
    
    /*
     Method used to delete the old file from the storagebase.
     */
    func consolidateStorage(oldReference: StorageReference) {
        
        oldReference.delete { error in
            
            if let e = error {
                
                print("No Deletion: \(e)")
            } else {
                
                print("Successful Delete")
            }
        }
    }
    
    /*
     Method used to upload the current references from the local StorageReference
     array to the database. This replaces all existing children in the imageLocations with the
     Reference values in the current local array.
     */
    func consolidateDataBase(){
        
        let databaseRef = Database.database().reference().child("user/" + CurrentUser.sharedInstance.userID + "/imageLocations")
        
        //Creating the array of values to be stored in the database
        var currentProfilePictureIDS = [String]()
        
        //Looping through the local array and uploading the file names to the method array
        CurrentUser.sharedInstance.imageReferencesArray.forEach { reference in
            
            currentProfilePictureIDS.append(reference.name)
        }
        
        //Uploading new values to the database
        databaseRef.setValue(currentProfilePictureIDS)
    }
    
    func deleteCellAtIndex(indexPath: IndexPath) {
        
        //let cell = pictureCollection?.cellForItem(at: indexPath)
        
        let oldReference = CurrentUser.sharedInstance.imageReferencesArray[indexPath.item]
        
        CurrentUser.sharedInstance.imageReferencesArray.remove(at: indexPath.item)
        
        consolidateStorage(oldReference: oldReference)
        
        consolidateDataBase()
        
        DispatchQueue.main.async {
            self.pictureCollection.reloadData()
        }
        
    }
}
