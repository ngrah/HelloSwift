//
//  ViewController.swift
//  helloSwift
//
//  Created by Nick Grah on 10/13/17.
//  Copyright © 2017 Nick Grah. All rights reserved.
//

import UIKit
import Foundation
import AWSCognitoIdentityProvider

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    // class to reload when success occurs
    func reloadViewFromNib() {
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }

 var pool: AWSCognitoIdentityUserPool?
 var sentTo: String?
//Mark: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // hide keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
  
       // DBTestLabel.text = textField.text
    }
    
    
    
//MARK: Properties
  
    // DBTest Screen
    @IBOutlet weak var DBTestLabel: UILabel!
    
    // Add new User
    // Username and password text fields
   
    @IBOutlet weak var newUserNameField: UITextField!
    
    @IBOutlet weak var newUserPassField: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    
    
    
    @IBAction func toSignUpButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toSignIn", sender: self)
    }
    
    
    
    
    // Testing Cells in table
    
    
    @IBOutlet weak var testName: UITextField!
    
    @IBOutlet weak var testPass: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let AWSCognitoUserPoolsSignInProviderKey = "UserPool"
        self.pool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
        
        // here I handle the new user name and password inputs through delegate callbacks
        newUserNameField.delegate = self
        newUserPassField.delegate = self
        email.delegate = self
        phone.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
//Mark: Actions
    
    
    
 
    @IBAction func signUp(_ sender: Any) {
        guard let userNameValue = self.newUserNameField.text, !userNameValue.isEmpty,
            let passwordValue = self.newUserPassField.text, !passwordValue.isEmpty else {
                let alertController = UIAlertController(title: "Missing Required Fields",
                                                        message: "Username / Password are required for registration.",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion:  nil)
                return
        }
        
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        
        if let phoneValue = self.phone.text, !phoneValue.isEmpty {
            let phone = AWSCognitoIdentityUserAttributeType()
            phone?.name = "phone_number"
            phone?.value = phoneValue
            attributes.append(phone!)
        }
        
        if let emailValue = self.email.text, !emailValue.isEmpty {
            let email = AWSCognitoIdentityUserAttributeType()
            email?.name = "email"
            email?.value = emailValue
            attributes.append(email!)
        }
        
        
        
        //sign up the user
        self.pool?.signUp(userNameValue, password: passwordValue, userAttributes: attributes, validationData: nil).continueWith {[weak self] (task) -> Any? in
            guard let strongSelf = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as? NSError {
                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                    alertController.addAction(retryAction)
                    
                    self?.present(alertController, animated: true, completion:  nil)
                } else if let result = task.result  {
                    // handle the case where user has to confirm his identity via email / SMS
                    if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
                        strongSelf.sentTo = result.codeDeliveryDetails?.destination
                        
                        
                        // When add user succeds, do something here
                        self?.reloadViewFromNib()
                        
                        
                        // this takes user to home page
                        //strongSelf.performSegue(withIdentifier: "confirmSignUpSegue", sender:sender)
                    } else {
                     //   let _ = strongSelf.navigationController?.popToRootViewController(animated: true)
                    }
                }
                
            })
            return nil
        }
    }
    
    
    @IBOutlet weak var signInUsername: UITextField!
    
    
    @IBOutlet weak var signInPassword: UITextField!
    
    var passwordAuthenticationCompletion:AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    var signInUsernameText: String?

    @IBAction func signIn(_ sender: Any) {
        if (self.signInUsername.text != nil && self.signInPassword.text != nil) {
            let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: self.signInUsername.text!,
              password: self.signInPassword.text!)
            self.passwordAuthenticationCompletion?.set(result: authDetails)
            
        
            
            
        } else {
            let alertController = UIAlertController(title: "Missing information",message: "Please enter a valid user name and password",preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
            alertController.addAction(retryAction)
        }

        
    }
    
    
    
    
    
    
    
}
extension ViewController: AWSCognitoIdentityPasswordAuthentication {
    
    public func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
        DispatchQueue.main.async {
            if (self.signInUsernameText == nil) {
                self.signInUsernameText = authenticationInput.lastKnownUsername
            }
        }
    }
    
    public func didCompleteStepWithError(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error as? NSError {
                let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                        message: error.userInfo["message"] as? String,
                                                        preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                alertController.addAction(retryAction)
                
                self.present(alertController, animated: true, completion:  nil)
            } else {
                self.signInUsername.text = nil
                self.dismiss(animated: true, completion: nil)
            }
        }
}
}
