//
//  lockInterface.swift
//  ParseStarterProject-Swift
//
//  Created by Wei Cai on 9/18/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class lockInterface: UIViewController {
    
    var mysubView:registerPop!
    
    @IBAction func registerKey(sender: AnyObject) {
        if(mysubView != nil && !mysubView.view.hidden){
            mysubView.view.removeFromSuperview()
        }
        let screensize:CGRect = UIScreen.mainScreen().bounds
        mysubView = registerPop(frame: screensize)
        mysubView.dismissB.addTarget(self, action: "removeAnimate:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(mysubView)
        mysubView.transform = CGAffineTransformMakeScale(1.3, 1.3)
        mysubView.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.mysubView.alpha = 1.0
            self.mysubView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });

           }
    
    func removeAnimate(sender:UIButton)
    {
        UIView.animateWithDuration(0.25, animations: {
            self.mysubView.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.mysubView.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                self.mysubView.view.removeFromSuperview()
                }
        });
        
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
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
