//
//  InitialViewController.swift
//  WallaLogin
//
//  Created by Dietrich Tribull on 7/19/16.
//  Copyright © 2016 Dietrich Tribull. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var wallaTitleLabel: UILabel!
    
    @IBOutlet weak var wallaLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        // Do any additional setup after loading the view, typically from a nib.
        formatLogo()
    }
    
    func formatLogo() {
        self.wallaLogo.layer.cornerRadius = self.wallaLogo.frame.size.width / 3
        self.wallaLogo.clipsToBounds = true
        self.wallaLogo.layer.borderWidth = 3.0
        self.wallaLogo.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

