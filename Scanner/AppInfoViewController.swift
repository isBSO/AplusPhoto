//
//  AppInfoViewController.swift
//  Scanner
//
//  Created by isBSO on 9/18/16.
//  Copyright © 2016 S. All rights reserved.
//

import UIKit

class AppInfoViewController: UIViewController {
    static func instantiate()-> AppInfoViewController
    {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AppInfoViewController") as! AppInfoViewController
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
