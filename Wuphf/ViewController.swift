//
//  ViewController.swift
//  Wuphf
//
//  Created by Avijeet Sachdev on 1/17/16.
//  Copyright (c) 2016 Avijeet Sachdev. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var noteTextview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNoteTextView()
        noteTextview.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showShareOptions(sender: AnyObject) {
        if noteTextview.isFirstResponder() {
            noteTextview.resignFirstResponder()
        }

        let actionSheet = UIAlertController(title: "", message: "Share your Message", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let tweetAction = UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.Default) { (action) -> Void in
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                if self.noteTextview.text.characters.count <= 140 {
                    twitterComposeVC.setInitialText("\(self.noteTextview.text)")
                }
                else {
                    let index = self.noteTextview.text.startIndex.advancedBy(140)
                    let subText = self.noteTextview.text.substringToIndex(index)
                    twitterComposeVC.setInitialText("\(subText)")
                }
                self.presentViewController(twitterComposeVC, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage("You are not logged in to your Twitter account.")
            }
        }
        let facebookPostAction = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                facebookComposeVC.setInitialText("\(self.noteTextview.text)")
                
                self.presentViewController(facebookComposeVC, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage("You are not connected to your Facebook account.")
            }
            
        }
        
        // Configure a new action to show the UIActivityViewController
        let moreAction = UIAlertAction(title: "More", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let activityViewController = UIActivityViewController(activityItems: [self.noteTextview.text], applicationActivities: nil)
            
            activityViewController.excludedActivityTypes = [UIActivityTypeMail]
            
            self.presentViewController(activityViewController, animated: true, completion: nil)
            
        }
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        actionSheet.addAction(tweetAction)
        actionSheet.addAction(facebookPostAction)
        actionSheet.addAction(moreAction)
        actionSheet.addAction(dismissAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    // MARK: Custom Functions
    func configureNoteTextView() {
        noteTextview.layer.cornerRadius = 8.0
        noteTextview.layer.borderColor = UIColor(white: 0.75, alpha: 0.5).CGColor
        noteTextview.layer.borderWidth = 1.2
    }
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "Wuphf for iOS", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    // MARK: UITextViewDelegate Functions
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}

