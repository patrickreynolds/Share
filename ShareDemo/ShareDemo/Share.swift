//
//  Share.swift
//  Quick Piq
//
//  Created by Patrick Reynolds on 11/20/15.
//  Copyright © 2015 Patrick Reynolds. All rights reserved.
//

import Foundation
import Social
import MessageUI

typealias ShareCompletion = (error: NSError?) -> ()

enum Source {
    case CameraRoll
    case Text
    case Email
    case Twitter
    case FaceBook
}

class PhotoAlbumSaver: NSObject {
    
    let image: UIImage
    let completion: (error: NSError?, image: UIImage) -> ()
    
    init(image: UIImage, completion: (error: NSError?, image: UIImage) -> ()) {
        self.image = image
        self.completion = completion
    }
    
    func save() {
        UIImageWriteToSavedPhotosAlbum(image, self, Selector("didSaveImage:didFinishSavingWithError:contextInfo:"), nil)
    }
    
    @objc func didSaveImage(image: UIImage, didFinishSavingWithError: NSError?, contextInfo:UnsafePointer<Void>) {
        completion(error: didFinishSavingWithError, image: image)
    }
}

class Share: NSObject {
    static let defaultInstance = Share()
    
    private override init() { }
    
    func sendImageToSource(source: Source, image: UIImage, presentingViewController vc: UIViewController, completion: ShareCompletion) {
        switch source {
        case .CameraRoll:
            saveImage(image, presentingViewController: vc, completion: completion)
        case .Text:
            sendTextWithImage(image, presentingViewController: vc, completion: completion)
        case .Email:
            sendEmailWithImage(image, presentingViewController: vc, completion: completion)
        case .Twitter:
            shareTwitterImage(image, presentingViewController: vc, completion: completion)
        case .FaceBook:
            shareFacebookImage(image, presentingViewController: vc, completion: completion)
        }
    }
}

// MARK: Camera Roll
extension Share {
    private func saveImage(image: UIImage, presentingViewController presentingVC: UIViewController, completion: ShareCompletion) {
        PhotoAlbumSaver(image: image, completion: { error, image in
            completion(error: nil)
        }).save()
    }
}

// MARK: Text
extension Share: MFMessageComposeViewControllerDelegate {
    private func sendTextWithImage(image: UIImage, presentingViewController presentingVC: UIViewController, completion: ShareCompletion) {
        if (MFMessageComposeViewController.canSendText()) {
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            messageVC.addAttachmentData(UIImagePNGRepresentation(image)!, typeIdentifier: "image/png", filename: "quick-piq.png")
            presentingVC.presentViewController(messageVC, animated: true) {
                completion(error: nil)
            }
        } else {
            completion(error: nil)
        }
    }
    
    @objc func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch result {
        case MessageComposeResultCancelled:
            print("Cancelled!")
        case MessageComposeResultSent:
            print("Sent!")
        case MessageComposeResultFailed:
            print("Failed!")
        default:
            print("Default")
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: Mail
extension Share: MFMailComposeViewControllerDelegate {
    private func sendEmailWithImage(image: UIImage, presentingViewController presentingVC: UIViewController, completion: ShareCompletion) {
        if MFMailComposeViewController.canSendMail() {
            let mc = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject("Quick Piq!")
            mc.addAttachmentData(UIImagePNGRepresentation(image)!, mimeType: "image/png", fileName: "quick-piq.png")
            presentingVC.presentViewController(mc, animated: true) {
                completion(error: nil)
            }
        } else {
            completion(error: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch (result) {
        case MFMailComposeResultCancelled:
            print("Cancelled!")
        case MFMailComposeResultSaved:
            print("Sent!")
        case MFMailComposeResultSent:
            print("Sent!")
        case MFMailComposeResultFailed:
            print("Failed!")
        default:
            print("Default")
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: Twitter
extension Share {
    func shareTwitterImage(image: UIImage, presentingViewController presentingVC: UIViewController, completion: ShareCompletion) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let twitterSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.addImage(image)
            presentingVC.presentViewController(twitterSheet, animated: true, completion: { _ in
                completion(error: nil)
            })
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentingVC.presentViewController(alert, animated: true, completion: { _ in
                completion(error: nil)
            })
        }
    }
}

// MARK: Facebook
extension Share {
    func shareFacebookImage(image: UIImage, presentingViewController presentingVC: UIViewController, completion: ShareCompletion) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let facebookSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.addImage(image)
            presentingVC.presentViewController(facebookSheet, animated: true, completion: { _ in
                completion(error: nil)
            })
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            presentingVC.presentViewController(alert, animated: true, completion: { _ in
                completion(error: nil)
            })
        }
    }
}
