//
//  ViewController.swift
//  AudioPlayerWithSlider
//
//  Created by Subroto Mohonto on 23/7/20.
//  Copyright © 2020 Subroto Mohonto. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate{
    
        var audioPlayer:AVAudioPlayer! = nil
        var timer:Timer!
        var audioLength = 0.0
        var totalAudioLength = ""
        var currentAudioPath:URL!

       @IBOutlet var progressTimerLbll : UILabel!
       @IBOutlet var playerProgressSlider : UISlider!
       @IBOutlet var totalLengthOfAudioLbl : UILabel!
       @IBOutlet var playerBtn : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAudio()
    }
    
    @IBAction func playBtn(_ sender: Any) {
        
        let play = UIImage(named: "play")
        let pause = UIImage(named: "pause")
        if audioPlayer.isPlaying{
            pauseAudioPlayer()
        }else{
            playAudio()
        }
        playerBtn.setImage(audioPlayer.isPlaying ? pause : play, for: UIControl.State())
    }
    
    @IBAction func changeAudioBySlider(_ sender: UISlider) {
        audioPlayer.currentTime = TimeInterval(sender.value)
        audioPlayer.play()
    }
    
    func  playAudio(){
        audioPlayer.play()
        startTimer()
    }
        
    func stopAudioplayer(){
        audioPlayer.stop();
            
    }
        
    func pauseAudioPlayer(){
        audioPlayer.pause()
            
    }
        
    func startTimer(){
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.update(_:)), userInfo: nil,repeats: true)
            timer.fire()
        }
    }
        
    func stopTimer(){
        timer.invalidate()
               
    }
           
    @objc func update(_ timer: Timer){
        if !audioPlayer.isPlaying{
            return
        }
        let time = calculateTimeFromNSTimeInterval(audioPlayer.currentTime)
        progressTimerLbll.text  = "\(time.minute):\(time.second)"
        playerProgressSlider.value = CFloat(audioPlayer.currentTime)
    }
        
    //song length returns
    func calculateTimeFromNSTimeInterval(_ duration:TimeInterval) ->(minute:String, second:String){
    
        let minute_ = abs(Int((duration/60).truncatingRemainder(dividingBy: 60)))
        let second_ = abs(Int(duration.truncatingRemainder(dividingBy: 60)))
        
        let minute = minute_ > 9 ? "\(minute_)" : "0\(minute_)"
        let second = second_ > 9 ? "\(second_)" : "0\(second_)"
        return (minute,second)
    }
        
    func prepareAudio(){
        currentAudioPath = URL(fileURLWithPath: Bundle.main.path(forResource: "tomar-khola-hawa-abid.mp3", ofType: nil)!)
        do {
                try AVAudioSession.sharedInstance().setActive(true)
          } catch _ {}
        UIApplication.shared.beginReceivingRemoteControlEvents()
        audioPlayer = try? AVAudioPlayer(contentsOf: currentAudioPath)
        audioPlayer.delegate = self
        audioLength = audioPlayer.duration
        playerProgressSlider.maximumValue = CFloat(audioPlayer.duration)
        playerProgressSlider.minimumValue = 0.0
        playerProgressSlider.value = 0.0
        audioPlayer.prepareToPlay()
        showTotalSongLength()
        progressTimerLbll.text = "00:00"
                
                
            }
        func showTotalSongLength(){
               calculateSongLength()
               totalLengthOfAudioLbl.text = totalAudioLength
           }
        
        func calculateSongLength(){
            let time = calculateTimeFromNSTimeInterval(audioLength)
            totalAudioLength = "\(time.minute):\(time.second)"
        }
        
    }



