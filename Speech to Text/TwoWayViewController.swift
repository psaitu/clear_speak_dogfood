//
//  TwoWayViewController.swift
//  Speech to Text
//
//  Created by Prabhu Saitu on 4/15/19.
//  Copyright © 2019 IBM Watson Developer Cloud. All rights reserved.
//

import UIKit

class TwoWayViewController: UIViewController {
    
    
    @IBOutlet weak var stopWordAnalysisButton: UIButton!
    
    @IBOutlet weak var pitchDeckButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        stopWordAnalysisButton.applyDesign()
        pitchDeckButton.applyDesign()
    }
    
    
    @IBAction func didTapStopWordsButton(_ sender: Any) {
        performSegue(withIdentifier: "showRecordVC", sender: self)
    }
    
    
    @IBAction func didTapPitchDeckButton(_ sender: Any) {
        performSegue(withIdentifier: "showPitchDeck", sender: self)
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
