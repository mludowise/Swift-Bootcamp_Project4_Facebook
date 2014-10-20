//
//  LoginViewController.swift
//  Facebook
//
//  Created by Mel Ludowise on 10/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

private let kEmail = "mel@melludowise.com"
private let kPassword = "password"

private let kLoginSegueID = "loginSegue"

class LoginViewController: UIViewController {

    @IBOutlet weak var loginComponentsView: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var loginYPos : CGFloat?
    private var loginHeight : CGFloat?
    private var screenHeight : CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginYPos = loginComponentsView.frame.origin.y
        loginHeight = loginComponentsView.frame.height
        screenHeight = UIScreen.mainScreen().bounds.height
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardWillShow(notification: NSNotification!) {
        var userInfo = notification.userInfo!
        var kbSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue().size
        self.loginComponentsView.frame.origin.y = self.screenHeight! - kbSize.height - self.loginHeight!
    }
    
    func keyboardWillHide(notification: NSNotification!) {
        var userInfo = notification.userInfo!
        var kbSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue().size
        self.loginComponentsView.frame.origin.y = self.loginYPos!
    }
    
    @IBAction func onEditingChanged(sender: UITextField) {
        loginButton.enabled = emailField.text != "" && passwordField.text != ""
    }
    
    @IBAction func onLoginButton(sender: AnyObject) {
        println("button")
        activityIndicator.startAnimating()
        loginButton.selected = true
        delay(2, { () -> () in
            if (self.emailField.text != kEmail || self.passwordField.text != kPassword) {
                self.loginButton.selected = false
                var alert = UIAlertView(title: "Incorrect Email or Password", message: "", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            } else {
                self.performSegueWithIdentifier(kLoginSegueID, sender: self)
            }
        })
    }
}
