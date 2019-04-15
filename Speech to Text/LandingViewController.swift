//
//  LandingViewController.swift
//  Speech to Text
//
//  Created by Prabhu Saitu on 4/15/19.
//  Copyright © 2019 IBM Watson Developer Cloud. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.signInButton.applyDesign()
    }
    
    
    
    @IBOutlet weak var signInButton: UIButton!
    
    
    @IBAction func didTapSignInButton(_ sender: Any) {
        performSegue(withIdentifier: "showTwoWaySegue", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
