//
//  ViewController.swift
//  ShareDemo
//
//  Created by Patrick Reynolds on 11/22/15.
//  Copyright © 2015 Patrick Reynolds. All rights reserved.
//

import UIKit

class ShareDemo: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var buttonShareImage: UIButton!
    @IBOutlet weak var buttonAddImage: UIButton!
    @IBOutlet weak var imageViewSelectedImagePreview: UIImageView!

    // MARK: Properties
    private var selectedImage: UIImage?

    // MARK: View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // MARK: UI Helpers
    private func updateUI() {
        if let image = selectedImage {
            showImage(image)
            showButtonAddImage(false)
            enableButtonShareImage(true)
        } else {
            showButtonAddImage(true)
            enableButtonShareImage(false)
        }
    }

    private func showButtonAddImage(show: Bool) {
        if show {
            buttonAddImage.alpha = 1
            view.bringSubviewToFront(buttonAddImage)
        } else {
            buttonAddImage.alpha = 0
        }
    }

    private func enableButtonShareImage(enable: Bool) {
        if enable {
            UIView.animateWithDuration(0.3, animations: { [weak self] in
                self?.buttonShareImage.enabled = true
                self?.buttonShareImage.alpha = 1
            }, completion: nil)
        } else {
            UIView.animateWithDuration(0.3, animations: { [weak self] in
                self?.buttonShareImage.enabled = false
                self?.buttonShareImage.alpha = 0.7
            }, completion: nil)
        }
    }

    private func showImage(image: UIImage) {
        UIView.animateWithDuration(0.15, animations: { [weak self] in
            self?.imageViewSelectedImagePreview.alpha = 0
            }, completion: { _ in
                UIView.animateWithDuration(0.15, animations: { [weak self] in
                    self?.imageViewSelectedImagePreview.alpha = 1
                    self?.imageViewSelectedImagePreview.image = image
                }, completion: nil)
        })
    }

    // MARK: Actions
    @IBAction func selectImage(sender: AnyObject) {
        if let _ = sender as? UIButton {
            selectImageFromCameraRoll()
        } else {
            selectImageFromCameraRoll()
        }
    }

    @IBAction func shareImageButtonPressed(sender: UIButton) {
        if let image = selectedImage {
            selectSourceForImage(image)
        }
    }
    
    // MARK: Share action sheet
    private func selectSourceForImage(image: UIImage) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Source", preferredStyle: .ActionSheet)

        // Save Image
        let saveAction = UIAlertAction(title: "Save", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            Share.defaultInstance.sendImageToSource(.CameraRoll, image: image, presentingViewController: self) { error in
                print("\(error)")
            }
        })

        // Text Image
        let textAction = UIAlertAction(title: "Text", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            Share.defaultInstance.sendImageToSource(.Text, image: image, presentingViewController: self) { error in
                print("\(error)")
            }
        })

        // Email Image
        let emailAction = UIAlertAction(title: "Email", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            Share.defaultInstance.sendImageToSource(.Email, image: image, presentingViewController: self) { error in
                print("\(error)")
            }
        })

        // Tweet Image
        let tweetAction = UIAlertAction(title: "Twitter", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            Share.defaultInstance.sendImageToSource(.Twitter, image: image, presentingViewController: self) { error in
                print("\(error)")
            }
        })

        // Post Image
        let postAction = UIAlertAction(title: "Facebook", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            Share.defaultInstance.sendImageToSource(.FaceBook, image: image, presentingViewController: self) { error in
                print("\(error)")
            }
        })

        // Cancel Share
        let cancelAction = UIAlertAction(title: "Nevermind", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
                print("Canceled")
        })

        optionMenu.addAction(saveAction)
        optionMenu.addAction(textAction)
        optionMenu.addAction(emailAction)
        optionMenu.addAction(tweetAction)
        optionMenu.addAction(postAction)
        optionMenu.addAction(cancelAction)

        presentViewController(optionMenu, animated: true, completion: nil)
    }
}

// MARK: Image Selection Methods
extension ShareDemo: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    private func selectImageFromCameraRoll() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String:AnyObject]) {
        var newImage: UIImage

        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }

        dismissViewControllerAnimated(true) { [weak self] in
            self?.selectedImage = newImage
            self?.updateUI()
        }
    }
}
