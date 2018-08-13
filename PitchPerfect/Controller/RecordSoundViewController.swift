//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Ashutosh Purushottam on 11/08/18.
//  Copyright © 2018 Ashutosh Purushottam. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioFileName: URL?

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false

        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        self.showRecordingPermissionDenied()
                    }
                }
            }
        } catch {
            self.showRecordingPermissionDenied()
        }
    }
    
    //MARK: - UI rendering

    func loadRecordingUI() {
        recordingLabel.isHidden = false
        recordButton.isHidden = false
        stopRecordingButton.isHidden = false
    }
    
    func showRecordingPermissionDenied() {
        recordingLabel.isHidden = false
        recordingLabel.text = "Permission denied to record audio. We can not proceed."
    }
    
    func showRecordingFailed() {
        recordingLabel.text = "Recording of sound failed. We regret the failure."
    }
    
    //MARK: - IBActions

    @IBAction func recordSoundPressed(_ sender: Any) {
        recordingLabel.text = "Recording in Progress"
        recordButton.isEnabled = false
        stopRecordingButton.isEnabled = true
        startRecording()
    }
    
    
    @IBAction func stopRecordingPressed(_ sender: Any) {
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "Tap to Record"
        finishRecording()
    }

    //MARK: - Recording start/stop

    func startRecording() {
        audioFileName = getDocumentsDirectory().appendingPathComponent("recordedVoice.wav")
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } catch {
            self.showRecordingFailed()
        }
    }
    
    func finishRecording() {
        audioRecorder.stop()
        audioRecorder = nil
    }
    
    //MARK: - AVAudioDelegate

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("audio recording finished")
        if flag {
            performSegue(withIdentifier: "recordSegue", sender: self)
        } else {
            showRecordingFailed()
        }
    }
    
    //MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recordSegue" {
            if segue.destination is PlaySoundViewController {
                let destinationController = segue.destination as! PlaySoundViewController
                destinationController.recordedAudioURL = audioFileName!
            }
        }
    }
    
    //MARK: - Helper methods

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    
}

