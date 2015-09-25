//
//  lockInterface.swift
//  ParseStarterProject-Swift
//
//  Created by Wei Cai on 9/18/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class lockInterface: UIViewController,UITableViewDelegate{
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let cUser = PFUser.currentUser()!.objectId!
    var mysubView:registerPop!
    var keyName = ""
    var keysN = [String]()
    var keys:[String:String]=[:]
    var keyselected = false
    var fixchallenge = ""
    var selectedRow: NSIndexPath?
    var logArray = [String]()
    
    @IBOutlet weak var keysTable: UITableView!
    
    
    func displayAlert(Title:String,Message:String){
        
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    
    @IBAction func unlock(sender: AnyObject) {
        if keyselected{
            PFCloud.callFunctionInBackground("unlock", withParameters: ["CUID":cUser,"NK":keyName], block: { (response, error) -> Void in
                print(response!)
            })
            
        }else{
            displayAlert("Error", Message: "Please select a key")
        }
    }
    
    
    @IBAction func History(sender: AnyObject) {
        if keyselected {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        PFCloud.callFunctionInBackground("lockLog", withParameters: ["CUID":cUser,"NK":keyName]) { (response, error) -> Void in
            self.logArray = response! as! [String]
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            self.performSegueWithIdentifier("logWay", sender: self)
            }
        }else{
            displayAlert("Error", Message: "Please select a key")
        }
        
    }
    
    @IBAction func logOut(sender: AnyObject) {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        PFUser.logOut()
        var currentUser = PFUser.currentUser()
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
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
        update()
        keysTable.reloadData()
        
    }

    @IBAction func retrive(sender: AnyObject) {
         update()
         keysTable.reloadData()

    }

    func update(){
        let getReg = PFQuery(className: "Register")
        self.keysN.removeAll(keepCapacity: true)
        self.keys=[:]
        NSUserDefaults.standardUserDefaults().setObject(self.keysN, forKey: "KeysN"+(PFUser.currentUser()?.objectId)!)
        NSUserDefaults.standardUserDefaults().setObject(self.keys, forKey: "Keys"+(PFUser.currentUser()?.objectId)!)
        getReg.whereKey("UserID", equalTo: PFUser.currentUser()!.objectId!)
        getReg.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let objects = objects{
                for object in objects{
                    let nk = object["nameOfKey"] as! String
                    let fc = object["fixChallenge"] as! String
                    self.keysN.append(nk)
                    self.keys[nk] = fc
                    NSUserDefaults.standardUserDefaults().setObject(self.keysN, forKey: "KeysN"+(PFUser.currentUser()?.objectId)!)
                    NSUserDefaults.standardUserDefaults().setObject(self.keys, forKey: "Keys"+(PFUser.currentUser()?.objectId)!)
                    self.keysTable.reloadData()
                }
            }
            
        })

    }
    
    func getRandomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 0.75)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (NSUserDefaults.standardUserDefaults().objectForKey("KeysN"+(PFUser.currentUser()?.objectId)!) != nil)&&(NSUserDefaults.standardUserDefaults().objectForKey("Keys"+(PFUser.currentUser()?.objectId)!) != nil) {
            keysN = NSUserDefaults.standardUserDefaults().objectForKey("KeysN"+(PFUser.currentUser()?.objectId)!) as! [String]
            keys = NSUserDefaults.standardUserDefaults().objectForKey("Keys"+(PFUser.currentUser()?.objectId)!) as! [String:String]
        }
        keysTable.reloadData()
       }

    
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
        return keysN.count
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! keyCells
        myCell.keyName.text = keysN[indexPath.row]
        myCell.backgroundColor = getRandomColor()
        return myCell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark

        if selectedRow != nil {
            cell = tableView.cellForRowAtIndexPath(selectedRow!)!
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        selectedRow = indexPath
        keyName = keysN[indexPath.row]
        fixchallenge = keys[keyName]!
        keyselected = true

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "logWay") {
            let destVc = segue.destinationViewController as! LogCtrl
            destVc.logArray = logArray
        }
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
