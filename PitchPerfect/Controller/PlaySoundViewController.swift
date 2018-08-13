//
//  PlaySoundViewController.swift
//  PitchPerfect
//
//  Created by Ashutosh Purushottam on 12/08/18.
//  Copyright © 2018 Ashutosh Purushottam. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    
    var recordedAudioURL:URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!

    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    enum ButtonType: Int { case slow = 0, fast, highPitch, lowPitch, echo, reverb}

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setContentViewMode()
        setupAudio()
    }
    
    func setContentViewMode() {
        slowButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        fastButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        highPitchButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        lowPitchButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        echoButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        reverbButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        stopButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
    }

    
    override func viewWillAppear(_ animated: Bool) {
        configureUI(.notPlaying)
    }
    
    
    
    @IBAction func playSoundPressed(_ sender: UIButton) {
        switch ButtonType(rawValue: sender.tag)! {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .highPitch:
            playSound(pitch: 1000)
        case .lowPitch:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(.playing)
        
    }
    
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        stopAudio()
    }
}
