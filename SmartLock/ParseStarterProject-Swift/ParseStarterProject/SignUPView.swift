//
//  SignUPView.swift
//  ParseStarterProject-Swift
//
//  Created by Wei Cai on 9/18/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

@available(iOS 8.0, *)
class SignUPView: UIViewController,UITextFieldDelegate {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(Title:String,Message:String,Return:Bool){
        
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if(Return){
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    
    @IBAction func backButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var PhoneNumber: UITextField!
    
    @IBAction func signUp(sender: AnyObject) {
        var errorMessage = "Please try again later"
        if (Email.text == "" || Password.text == "" || Name.text == ""){
            displayAlert("Error", Message: "Please enter all the required infomation",Return: false)
        }else{
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            var user = PFUser()
            var userName = Email.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            user.username = userName
            user.password = Password.text
            user.email = userName
            user["Phone"]=PhoneNumber.text
            user["Name"]=Name.text
            user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil {
                    self.displayAlert("Successed", Message: "You have created an account",Return: true)
                    
                }else{
                    if let errorString = error!.userInfo["error"] as? String{
                        errorMessage = errorString
                    }
                    self.displayAlert("Failed Sign Up", Message: errorMessage,Return: false)
                }
                
            })
            
        }

        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.Name.delegate = self
        self.Password.delegate = self
        self.Email.delegate = self
        self.PhoneNumber.delegate = self

        // Do any additional setup after loading the view.
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
