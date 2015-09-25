/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

@available(iOS 8.0, *)
class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(Title:String,Message:String){
        
            let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertControllerStyle.Alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func signUpButton(sender: AnyObject) {
            }

    @IBAction func loginButton(sender: AnyObject) {
        var errorMessage = "Please try again later"
        if (userName.text == "" || passWord.text == ""){
            displayAlert("Error", Message: "Please enter both your username and password")
        }else{
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            PFUser.logInWithUsernameInBackground(userName.text!, password: passWord.text!, block: { (user, error) -> Void in
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                if user != nil {
                    self.performSegueWithIdentifier("Logined", sender: self)
                    
                }else{
                    if let errorString = error!.userInfo["error"] as? String{
                        print(errorString)
                        errorMessage = "Please check your username and password"
                    }
                    self.displayAlert("Failed Login", Message: errorMessage)
                    
                }
            })
        }
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.userName.delegate = self
        self.passWord.delegate = self
        
      /*  PFCloud.callFunctionInBackground("cal", withParameters: ["ID":"lala"]) { (response, error) -> Void in
            println(response!)}*/
    }
    
    override func viewDidAppear(animated: Bool) {
       if ((PFUser.currentUser()?.objectId) != nil){
           self.performSegueWithIdentifier("Logined", sender: self)
        }
        
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
}
