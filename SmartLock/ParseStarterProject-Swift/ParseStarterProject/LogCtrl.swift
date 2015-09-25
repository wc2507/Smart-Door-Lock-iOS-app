//
//  LogCtrl.swift
//  ParseStarterProject-Swift
//
//  Created by Wei Cai on 9/24/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class LogCtrl: UIViewController,UITableViewDelegate {
    
    var logArray:[String]!
    
    @IBAction func backB(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(logArray)

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        print(logArray)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return logArray.count
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let mycell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! logCell
        var info = logArray[indexPath.row].componentsSeparatedByString("/")
        mycell.name.text = info[0]
        mycell.status.text = info[1]
        mycell.time.text = info[2]
        return mycell
        
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
