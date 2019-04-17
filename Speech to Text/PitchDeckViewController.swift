//
//  PitchDeckViewController.swift
//  Speech to Text
//
//  Created by Prabhu Saitu on 4/15/19.
//  Copyright © 2019 IBM Watson Developer Cloud. All rights reserved.
//

import UIKit
import AVFoundation
import SpeechToTextV1


class PitchDeckViewController: RecordingViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction override func didPressRecordButton(_ sender: Any) {
        
        if audioRecorder?.isRecording == false {
            playButton.isEnabled = false
            resultsLabel.text = "Recording in progress...."
            self.analysisLabel.text = ""
            recordButton.setTitle("Stop Recording", for: .normal)
            audioRecorder?.record()
            print("Recording..")
        } else {
            resultsLabel.text = "Recording stopped...."
            playButton.isEnabled = true
            audioRecorder?.stop()
            recordButton.setTitle("Start Recording", for: .normal)
            print("Stopped..")
        }
        
    }
    
    
    @IBAction override func didPressPlayButton(_ sender: Any) {
        
        if audioRecorder?.isRecording == false {
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOf:
                    (audioRecorder?.url)!)
                audioPlayer!.delegate = self
                audioPlayer!.setVolume(0.9, fadeDuration: 0.1)
                self.analysisLabel.text = ""
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
                playButton.setTitle("Stop Audio", for: .normal)
                resultsLabel.text = "Playing audio...."
            } catch let error as NSError {
                print("audioPlayer error: \(error.localizedDescription)")
            }
            
            //            if audioPlayer?.isPlaying == false {
            //
            //            } else {
            //                audioPlayer?.stop()
            //                resultsLabel.text = "Audio Stopped!"
            //                playButton.setTitle("Play Audio", for: .normal)
            //            }
            
            
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
}
