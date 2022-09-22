//
//  ViewController.swift
//  BackgroundModes
//
//  Created by AbdurRehmanNineSol on 13/09/2022.
//

import UIKit
import AVKit
import MediaPlayer
import AVFoundation
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    var timer: Timer?
    @Published var isPlaying = false
    var audioPlayer: AVAudioPlayer?
    var timeCounter: Int = 0
    var airPlay = UIView()
    
    
    static var songs: [URL] = {
        // find the mp3 song files in the bundle and return player item for each
        let songList = ["FeelinGood", "IronBacon", "WhatYouWant"]
        return songList.map {
            guard let url = Bundle.main.url(forResource: $0, withExtension: "mp3") else {
                return nil
            }
            return url
        }
        .compactMap { $0 }
    }()

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupAirPlayBtn()
        guard let url = Bundle.main.url(forResource: "FeelinGood", withExtension: "mp3") else { return }

           do {
               try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
               try AVAudioSession.sharedInstance().setActive(true)

               audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

               audioPlayer?.volume = 1

           } catch let error {
               print(error.localizedDescription)
           }
        
        let navBtn = UIBarButtonItem(customView: airPlay)
        self.navigationItem.rightBarButtonItem = navBtn
    }

    @objc func fireTimer() {
        timeCounter += 1
        let currentTime1 = Int((audioPlayer?.currentTime)!)
        let minutes = currentTime1/60
        let seconds = currentTime1 - minutes * 60
        
        if UIApplication.shared.applicationState == .active {
            timeLabel.text  = NSString(format: "%02d:%02d", minutes,seconds) as String
        } else {
            print("App is playing in background mode : \(timeCounter)")
        }
    }

    @IBAction func tapPlayPauseBtn(_ sender: UIButton) {
        songName.text = "FeelinGood"
        if sender.titleLabel?.text == "Play" {
            sender.setTitle("Pause", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
            audioPlayer?.play()
        } else {
            sender.setTitle("Play", for: .normal)
            timer?.invalidate()
            audioPlayer?.pause()
        }
    }
    
    func setupAirPlayBtn() {
        airPlay.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let routerPickerView = AVRoutePickerView(frame: buttonView.bounds)
        routerPickerView.tintColor = .black
        routerPickerView.activeTintColor = .green
        buttonView.addSubview(routerPickerView)
        self.airPlay.addSubview(buttonView)
    }
    
}

