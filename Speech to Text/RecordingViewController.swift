//
//  RecordingViewController.swift
//  Speech to Text
//
//  Created by Prabhu Saitu on 4/1/19.
//  Copyright © 2019 IBM Watson Developer Cloud. All rights reserved.
//

import UIKit
import AVFoundation
import SpeechToTextV1

extension UIButton{
    func applyDesign(){
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.setTitleColor(UIColor.black, for: .normal)
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = 6
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.borderWidth = 0.8
    }
}

extension String {
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
            !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
}

class RecordingViewController: UIViewController {
    
    
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var speechToText: SpeechToText!
    var accumulator = SpeechRecognitionResultsAccumulator()
    
    
    @IBOutlet weak var analysisLabel: UILabel!
    
    @IBOutlet weak var analyzeRecordingButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechToText = SpeechToText(
            apiKey: Credentials.SpeechToTextApiKey
        )
        
        setupAudioSettings()
        recordButton.applyDesign()
        playButton.applyDesign()
        analyzeRecordingButton.applyDesign()
        
        self.title = "Clear Speak"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    @IBAction func didTapExitButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func setupAudioSettings() {
        
        let fileManager = FileManager.default
        let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        
        let dfString = df.string(from: Date())
        
        
        let soundFileURL = dirPaths[0].appendingPathComponent("file-\(dfString)-sound.wav")
        
        let recorderSettings = [
            AVFormatIDKey:Int(kAudioFormatLinearPCM),
            AVSampleRateKey:44100.0,
            AVNumberOfChannelsKey:1,
            AVLinearPCMBitDepthKey:8,
            AVLinearPCMIsFloatKey:false,
            AVLinearPCMIsBigEndianKey:false,
            AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
            ] as [String : Any]
        
        let recordingSession = AVAudioSession.sharedInstance()
        
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.defaultToSpeaker])
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recorderSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
    }
    
    
    @IBAction func didPressRecordButton(_ sender: Any) {
        
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
    
    
    @IBAction func didPressPlayButton(_ sender: Any) {
        
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
    }
    
    func findOccurancesOfKeyword(source:String, keyword:String) -> [Int] {
        return source.indicesOf(string: keyword)
    }
    
    func analyzeBestTranscript(text:String) {
        
        // Get Hesitations
        let hesitations:[Int] = findOccurancesOfKeyword(source: text, keyword: "[Filler Word]")
        // So
        let sos:[Int] = findOccurancesOfKeyword(source: text, keyword: "so")
        
        // Like
        let like:[Int] = findOccurancesOfKeyword(source: text, keyword: "like")
        
        var analysisString = "==========================="
        analysisString += "\n Analysis"
        analysisString += "\n"
        analysisString += "\n So: \(sos.count)"
        analysisString += "\n Like: \(like.count)"
        analysisString += "\n Filler Words: \(hesitations.count)"
        
        
        
        self.analysisLabel.text = analysisString
        
    }
    
    @IBAction func didPressAnalyzeRecordingButton(_ sender: Any) {
        var settings = RecognitionSettings(contentType: "audio/wav")
        settings.interimResults = true
        resultsLabel.text = "Analyzing recording...."
        speechToText.recognize(audio: (audioRecorder?.url)!, settings: settings) {
            
            response, error in
            if let error = error {
                print(error)
            }
            guard let results = response?.result else {
                print("Failed to recognize the audio")
                return
            }
            self.accumulator.add(results: results)
            var bestTranscript:String = self.accumulator.bestTranscript
            
            bestTranscript = bestTranscript.replacingOccurrences(of: "%HESITATION", with: "[Filler Word]")
            
            self.resultsLabel.text = bestTranscript
            self.analyzeBestTranscript(text: bestTranscript)
            
            
        }
    }
    
}


extension RecordingViewController: AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }
    
}
