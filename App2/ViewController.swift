//
//  ViewController.swift
//  App2
//
//  Created by Robin on 15/04/2019.
//  Copyright © 2019 Robin. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
   
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var mapsButton: UIButton!
    @IBOutlet weak var savedTripsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SaveData.shared.load()
        logoImageView.image = UIImage(named: "logo.png")
        self.view.backgroundColor = UIColor(named: "bakgroundColor")
        if let navBar = self.navigationController{
            navBar.navigationBar.barTintColor = UIColor(named: "navBarColor")
        }
      buttonDesign(button: mapsButton)
      buttonDesign(button: savedTripsButton)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func buttonDesign(button: UIButton){
        button.backgroundColor = UIColor(named: "navBarColor")
        button.setTitleColor(UIColor(named: "whiteColor"), for: .normal)
        button.layer.cornerRadius = 25
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
    }

}

