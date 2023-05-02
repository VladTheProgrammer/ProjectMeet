//
//  ProfileCollectionView.swift
//  project18
//
//  Created by GOVIND on 2/8/18.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import UIKit
import GBHFacebookImagePicker
import Firebase
import FirebaseStorageUI

protocol SelectedUploadSource: class {
    func selectFromFacebook()
    func selectFromGallery()
    func dismissLoadingScroller()
}


class SelectionViewController: UIViewController {
    
    var selectedUploadSourceDelegate: SelectedUploadSource?
    
    
    let selectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.black.cgColor
        //view.layer.borderWidth = 1
        return view
    }()
    
    let selectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Import Photo From:"
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        label.layer.borderColor = UIColor.black.cgColor
        //label.layer.borderWidth = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var importFromFacebookButton: UIButton = {
        let button = UIButton()
        button.setTitle("Facebook", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = ColorSelector.SELECTED_COLOR
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(selectFromFacebook), for: .touchUpInside)
        return button
    }()
    
    lazy var importFromGalleryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Gallery", for: .normal)
        button.backgroundColor = ColorSelector.SELECTED_COLOR
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(selectFromGallery), for: .touchUpInside)
        //button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        return button
    }()
    
    @objc func viewTapped() {
        self.dismiss(animated: false, completion: {
            self.selectedUploadSourceDelegate?.dismissLoadingScroller()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        
        view.addGestureRecognizer(tapGestureRecognizer)
        
        selectionView.addSubview(selectionLabel)
        selectionView.addSubview(importFromFacebookButton)
        selectionView.addSubview(importFromGalleryButton)
        
        
        selectionLabel.anchorWithConstantsToTop(selectionView.topAnchor, left: selectionView.leftAnchor, bottom: nil, right: selectionView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        _ = importFromFacebookButton.anchor(selectionLabel.bottomAnchor, left: selectionView.leftAnchor, bottom: nil, right: selectionView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 40)
        
        _ = importFromGalleryButton.anchor(importFromFacebookButton.bottomAnchor, left: selectionView.leftAnchor, bottom: selectionView.bottomAnchor, right: selectionView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 40)
        
        view.addSubview(selectionView)
        
        selectionView.autoCenterInSuperview()
        
        selectionView.widthAnchor.constraint(equalToConstant: 240).isActive = true
        selectionView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @objc func selectFromFacebook() {
        selectedUploadSourceDelegate?.selectFromFacebook()
    }
    
    @objc func selectFromGallery() {
        selectedUploadSourceDelegate?.selectFromGallery()
    }
}

class ProfileCollectionView: UIView,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,GBHFacebookImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, deletePhoto, SelectedUploadSource {
    func dismissLoadingScroller() {
        loadingScroller.hideOverlayView()
    }
    
    
    
    
    var parentvc: UIViewController?
    
    
    var selectedindex = 0
    
    lazy var selectionViewController: SelectionViewController = {
        let viewController = SelectionViewController()
        viewController.selectedUploadSourceDelegate = self
        return viewController
        
    }()
    
    let faceBookImagePicker: GBHFacebookImagePicker = {
        let picker = GBHFacebookImagePicker()
        return picker
    }()
    
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    
    
    
   
    
    
    
    /// Cell identifier
    fileprivate let reuseIdentifier = "Cell"


    
    /// The collection view where are display the pictures
    lazy var pictureCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.allowsMultipleSelection = false
        cv.backgroundColor = .white
        return cv
    }()
    
    /// Array which contain image model of pictures which are in the album
    
    fileprivate var imageArray: [String] = ["","","","","",""]
    
    let loadingScroller: LoadingOverlay = {
        let scroller = LoadingOverlay()
        scroller.activityIndicator.color = ColorSelector.SELECTED_COLOR
        return scroller
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareCollectionView()
        
        
//        selectionView.addSubview(selectionLabel)
//        selectionView.addSubview(importFromFacebookButton)
//        selectionView.addSubview(importFromGallery)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Could not initialize ProfileCV")
    }
 
    func prepareCollectionView() {
        
        
        
        addSubview(pictureCollection)
        
        
        pictureCollection.anchorWithConstantsToTop(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        
        
        
       pictureCollection.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let difference = 6 - CurrentUser.sharedInstance.imageReferencesArray.count
        return difference + CurrentUser.sharedInstance.imageReferencesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        // Retrieve the selected image
        let cell = collectionView.cellForItem(at: indexPath) as! ProfileCollectionViewCell
        loadingScroller.showOverlay(view: cell.imageView)
        selectedindex = indexPath.item

        selectionViewController.modalPresentationStyle = .overCurrentContext
        parentvc?.present(selectionViewController, animated: false, completion: nil)
   
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! ProfileCollectionViewCell
        
        if CurrentUser.sharedInstance.imageReferencesArray.count > indexPath.item
            
        {
            
            let reference = CurrentUser.sharedInstance.imageReferencesArray[indexPath.item]
            
            cell.deletePhotoDelegate = self
            cell.deleteButton.isHidden = false
            cell.currentIndexPath = indexPath
            
            DispatchQueue.main.async {
                cell.imageView.sd_setImage(with: reference)
                self.loadingScroller.hideOverlayView()
            }
            
            
        } else {
            cell.deleteButton.isHidden = true
            cell.imageView.image = nil
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4,
                            left: 4,
                            bottom: 4,
                            right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - 16) / 3
        return CGSize(width: size,
                      height: size)
    }
    
    
    func facebookImagePicker(imagePicker: UIViewController,
                             successImageModels: [GBHFacebookImage],
                             errorImageModels: [GBHFacebookImage],
                             errors: [Error?]) {
        // Append selected image(s)
        // Do what you want with selected image
        //self.imageModels.append(contentsOf: successImageModels)
        print(successImageModels)
        if successImageModels.count>0
        {
            let selectedimagemodel = successImageModels[0]
//            if let imgurl =  selectedimagemodel.fullSizeUrl
//            {
//                self.imageArray[selectedindex] = imgurl
//            }
            if let imgSource = selectedimagemodel.fullSizeUrl{
                let imgSourceAsURL = URL(string: imgSource)
                let newImageReference = self.handleImageReferencing(imgUrl: imgSourceAsURL!)
                
                if CurrentUser.sharedInstance.imageReferencesArray.count > selectedindex{
                    let oldImageReference = CurrentUser.sharedInstance.imageReferencesArray[selectedindex]
                    self.consolidateStorage(oldReference: oldImageReference)
                    
                    
                    
                    CurrentUser.sharedInstance.imageReferencesArray[selectedindex] = newImageReference
                } else {
                    CurrentUser.sharedInstance.imageReferencesArray.append(newImageReference)
                }
                
                
                
                self.handleUrlToDownload(sourceUrl: imgSource)
                
                self.consolidateDataBase()
               
                
                
            }
        }
    }
    
    func facebookImagePicker(imagePicker: UIViewController, didFailWithError error: Error?) {
        print("Cancelled Facebook Album picker with error")
        print(error.debugDescription)
    }
    
    // Optional
    func facebookImagePicker(didCancelled imagePicker: UIViewController) {
        print("Cancelled Facebook Album picker")
        loadingScroller.hideOverlayView()
       
    }
    
    // Optional
    func facebookImagePickerDismissed() {
        print("Picker dismissed")
        loadingScroller.hideOverlayView()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        loadingScroller.hideOverlayView()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("picked image")
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as! UIImage? {
            print(editedImage.size)
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as! UIImage? {
            print(originalImage.size)
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            let imageReferenceString = UserService.randomAlphaNumericString(length: 19)
            
            let url = URL(string: imageReferenceString)
            
            handleImageUpload(image: selectedImage, originalLocation: url!, completionHandler: {
                print("Image uploaded.... somehow")
                let newImageReference = self.handleImageReferencing(imgUrl: url!)
                if CurrentUser.sharedInstance.imageReferencesArray.count > self.selectedindex{
                    let oldImageReference = CurrentUser.sharedInstance.imageReferencesArray[self.selectedindex]
                    self.consolidateStorage(oldReference: oldImageReference)
                    
                    
                    
                    CurrentUser.sharedInstance.imageReferencesArray[self.selectedindex] = newImageReference
                } else {
                    CurrentUser.sharedInstance.imageReferencesArray.append(newImageReference)
                }
                
                
                
                self.consolidateDataBase()
                
                DispatchQueue.main.async {
                    self.pictureCollection.reloadData()
                }
            })
            
            
        } else {
            print("Error uploading image")
        }
        
        loadingScroller.hideOverlayView()
        picker.dismiss(animated: true, completion: nil)
    }
    func selectFromGallery() {
        selectionViewController.dismiss(animated: false, completion: nil)
        parentvc?.present(imagePicker, animated: true, completion: nil)
    }
    
    func selectFromFacebook() {
        selectionViewController.dismiss(animated: false, completion: nil)
        faceBookImagePicker.presentFacebookAlbumImagePicker(from: parentvc!, delegate: self)
    }
    
}
