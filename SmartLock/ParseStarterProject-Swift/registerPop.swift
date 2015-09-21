//
//  registerPop.swift
//  ParseStarterProject-Swift
//
//  Created by Wei Cai on 9/19/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse
class registerPop: UIView {
    
    var view:UIView!
    @IBOutlet weak var popTitle: UILabel!
    @IBOutlet weak var KeyID: UITextField!
    @IBOutlet weak var keyName: UITextField!
    @IBOutlet weak var dismissB: UIButton!
    @IBAction func registerB(sender: AnyObject) {
        
    if(KeyID != nil && keyName != nil){
      let cUser = PFUser.currentUser()!.objectId!
      let PID = KeyID.text
      let nKey = keyName.text
        PFCloud.callFunctionInBackground("Reg", withParameters: ["ID":PID!,"CUID":cUser,"nKey":nKey!]) { (response, error) -> Void in
                print(response!)}
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
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "registerPop", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }

   

}

