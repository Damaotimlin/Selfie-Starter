//
//  ViewController.swift
//  Selfie
//
//  Created by Behera, Subhransu on 29/8/14.
//  Copyright (c) 2014 subhb.org. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var signinBackgroundView: UIView!
  @IBOutlet weak var signupBackgroundView: UIView!
  @IBOutlet weak var signinEmailTextField: UITextField!
  @IBOutlet weak var signinPasswordTextField: UITextField!
  @IBOutlet weak var signupNameTextField: UITextField!
  @IBOutlet weak var signupEmailTextField: UITextField!
  @IBOutlet weak var signupPasswordTextField: UITextField!
  @IBOutlet weak var activityIndicatorView: UIView!
  @IBOutlet weak var passwordRevealBtn: UIButton!
  
  let httpHelper = HTTPHelper()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    self.activityIndicatorView.layer.cornerRadius = 10
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func passwordRevealBtnTapped(sender: AnyObject) {
    self.passwordRevealBtn.selected = !self.passwordRevealBtn.selected
    
    if self.passwordRevealBtn.selected {
      self.signupPasswordTextField.secureTextEntry = false
    }
      
    else {
      self.signupPasswordTextField.secureTextEntry = true
    }
  }
  
  func displaSigninView () {
    self.signinEmailTextField.text = nil
    self.signinPasswordTextField.text = nil
    
    if self.signupNameTextField.isFirstResponder() {
      self.signupNameTextField.resignFirstResponder()
    }
    
    if self.signupEmailTextField.isFirstResponder() {
      self.signupEmailTextField.resignFirstResponder()
    }
    
    if self.signupPasswordTextField.isFirstResponder() {
      self.signupPasswordTextField.resignFirstResponder()
    }
    
    if self.signinBackgroundView.frame.origin.x != 0 {
      UIView.animateWithDuration(0.8, animations: { () -> Void in
        self.signupBackgroundView.frame = CGRectMake(320, 134, 320, 284)
        self.signinBackgroundView.alpha = 0.3
        
        self.signinBackgroundView.frame = CGRectMake(0, 134, 320, 284)
        self.signinBackgroundView.alpha = 1.0
        }, completion: nil)
    }
  }
  
  func displaySignupView () {
    self.signupNameTextField.text = nil
    self.signupEmailTextField.text = nil
    self.signupPasswordTextField.text = nil
    
    if self.signinEmailTextField.isFirstResponder() {
      self.signinEmailTextField.resignFirstResponder()
    }
    
    if self.signinPasswordTextField.isFirstResponder() {
      self.signinPasswordTextField.resignFirstResponder()
    }
    
    if self.signupBackgroundView.frame.origin.x != 0 {
      UIView.animateWithDuration(0.8, animations: { () -> Void in
        self.signinBackgroundView.frame = CGRectMake(-320, 134, 320, 284)
        self.signinBackgroundView.alpha = 0.3;
        
        self.signupBackgroundView.frame = CGRectMake(0, 134, 320, 284)
        self.signupBackgroundView.alpha = 1.0
        
        }, completion: nil)
    }
  }
  
  func displayAlertMessage(alertTitle:String, alertDescription:String) -> Void {
    // hide activityIndicator view and display alert message
    self.activityIndicatorView.hidden = true
    let errorAlert = UIAlertView(title:alertTitle, message:alertDescription, delegate:nil, cancelButtonTitle:"OK")
    errorAlert.show()
  }
  
  @IBAction func createAccountBtnTapped(sender: AnyObject) {
    self.displaySignupView()
  }
  
  @IBAction func cancelBtnTapped(sender: AnyObject) {
    self.displaSigninView()
  }
  
  
  @IBAction func signupBtnTapped(sender: AnyObject) {
    // Code to hide the keyboards for text fields
    if self.signupNameTextField.isFirstResponder() {
      self.signupNameTextField.resignFirstResponder()
    }
    
    if self.signupEmailTextField.isFirstResponder() {
      self.signupEmailTextField.resignFirstResponder()
    }
    
    if self.signupPasswordTextField.isFirstResponder() {
      self.signupPasswordTextField.resignFirstResponder()
    }
    
    // start activity indicator
    self.activityIndicatorView.hidden = false
    
    // validate presence of all required parameters
    if self.signupNameTextField.text?.characters.count > 0 && self.signupEmailTextField.text?.characters.count > 0 && self.signupPasswordTextField.text?.characters.count > 0 {
        makeSignUpRequest(self.signupNameTextField.text!, userEmail: self.signupEmailTextField.text!, userPassword: self.signupPasswordTextField.text!)
    } else {
        self.displayAlertMessage("Parameters Required", alertDescription: "Some of the parameters are missing")
    }
  }
  
  @IBAction func signinBtnTapped(sender: AnyObject) {
    // resign the keyboard for text fields
    if self.signinEmailTextField.isFirstResponder() {
      self.signinEmailTextField.resignFirstResponder()
    }
    
    if self.signinPasswordTextField.isFirstResponder() {
      self.signinPasswordTextField.resignFirstResponder()
    }
  }
  
  func updateUserLoggedInFlag() {
  }
  
  func saveApiTokenInKeychain(tokenDict:NSDictionary) {
  }
  
  func makeSignUpRequest(userName:String, userEmail:String, userPassword:String) {
    // 1. Create HTTP request and set rewiest header
    let httpRequest = httpHelper.buildRequest("signup", method: "POST", authType: HTTPRequestAuthType.HTTPBasicAuth)
    
    // 2. Passward is encrypted with the API key
    let encrypted_password = AESCrypt.encrypt(userPassword, password: HTTPHelper.API_AUTH_PASSWORD)
    
    // 3. Send the request Body
    httpRequest.HTTPBody = "{\"full_name\":\"\(userName)\", \"email\":\"\(userEmail)\", \"password\":\"\(encrypted_password)\"}".dataUsingEncoding(NSUTF8StringEncoding)
    
    // 4. Send the request
    httpHelper.sendRequest(httpRequest, completion: {
        (data: NSData!, error: NSError!) in
        if error != nil {
            let errorMessage = self.httpHelper.getErrorMessage(error)
            self.displayAlertMessage("ERROR", alertDescription: errorMessage as String)
            
            return
        }
        
        self.displaySignupView()
        self.displayAlertMessage("Success", alertDescription: "Account has been created")
    })
    
    
  }
  
  func makeSignInRequest(userEmail:String, userPassword:String) {   
  }
}
