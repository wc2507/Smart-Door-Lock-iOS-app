//
//  registerPop.swift
//  ParseStarterProject-Swift
//
//  Created by Wei Cai on 9/19/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse
class registerPop: UIView,UITextFieldDelegate {
    
    var view:UIView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var popTitle: UILabel!
    @IBOutlet weak var KeyID: UITextField!
    @IBOutlet weak var keyName: UITextField!
    @IBOutlet weak var dismissB: UIButton!
    @IBOutlet weak var resMsg: UILabel!
    @IBAction func registerB(sender: AnyObject) {
        
    if(KeyID != nil && keyName != nil){
      let cUser = PFUser.currentUser()!.objectId!
      let PID = KeyID.text
      let nKey = keyName.text
        //call indicator
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        // stop interaction
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        PFCloud.callFunctionInBackground("Reg", withParameters: ["ID":PID!,"CUID":cUser,"nKey":nKey!]) { (response, error) -> Void in
            self.resMsg.text = (response! as! String)
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
          }
        }


    }

    
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    func setup(){
        view = loadViewFromNib()
        view.frame = bounds
        addSubview(view)
        self.KeyID.delegate = self
        self.keyName.delegate = self
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "registerPop", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }

   

}

