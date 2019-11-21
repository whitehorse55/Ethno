//
//  OpenMicViewController.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/10.
//  Copyright © 2019 Ethno. All rights reserved.
//

import UIKit
import AVFoundation
import MessageUI

class OpenMicViewController: ViewController, MFMailComposeViewControllerDelegate {

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer  : AVAudioPlayer!
    
    @IBOutlet weak var recordbutton: UIButton!
    @IBOutlet weak var playbutton: UIButton!
    @IBOutlet weak var sendbutton: UIButton!
    @IBOutlet weak var deletebutton: UIButton!
    
    let filename = "record.m4a"
    var isrecording = false
    let mailComposer = MFMailComposeViewController()
    var isplaying = false
    override func viewDidLoad() {
        super.viewDidLoad()
        mailComposer.mailComposeDelegate = self
        
        setnavigationbuttons()
        initaudio()
        recordbutton.setBackgroundImage(UIImage(named: "openrecord_inactive"), for: .normal)
        enablerecordview()
    }
     
    func enablerecordview(){
        playbutton.isEnabled = false
        sendbutton.isEnabled = false
        deletebutton.isEnabled = false
    }
          
      func enableplayview(){
          playbutton.isEnabled = true
          sendbutton.isEnabled = true
          deletebutton.isEnabled = true
      }
    
    
    private func initaudio()
    {
        recordingSession = AVAudioSession.sharedInstance()

        do {
            if #available(iOS 10.0, *) {
                try recordingSession.setCategory(.playAndRecord, mode: .default)
            } else {
                // Fallback on earlier versions
            }
            
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                    } else {
                        // failed to record!
                        self.showToast(message: "Failed to record", font: UIFont(name: "Baufra-Bold", size: 16)!)
                    }
                }
            }
        } catch {
             self.showToast(message: "Failed to record", font: UIFont(name: "Baufra-Bold", size: 16)!)
        }
    }
    
    
   
    @IBAction func onclicksendbutton(_ sender: Any) {
        if(MFMailComposeViewController.canSendMail() ) {
                print("Can send email.")
                //Set the subject and message of the email
                mailComposer.setSubject("Voice Note")
                mailComposer.setMessageBody("Voice test. could you check your inbox?", isHTML: false)
                mailComposer.setToRecipients(["Afishadeveloper@gmail.com"])

                if let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as? String {
                    let fileManager = FileManager.default
                    let filecontent = fileManager.contents(atPath: docsDir + "/" + filename)
                    mailComposer.addAttachmentData(filecontent!, mimeType: "audio/wav", fileName: filename)
                    self.present(mailComposer, animated: true, completion: nil)
                }
            }
        
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
              case MFMailComposeResult.cancelled.rawValue:
                     print("Mail cancelled")
                     controller.dismiss(animated: true, completion: nil)
              case MFMailComposeResult.saved.rawValue:
                     print("Mail saved")
                     controller.dismiss(animated: true, completion: nil)
              case MFMailComposeResult.sent.rawValue:
                     print("Mail sent")
                     controller.dismiss(animated: true, completion: nil)
              case MFMailComposeResult.failed.rawValue:
                     print("Mail sent failure.")
                     controller.dismiss(animated: true, completion: nil)
                 default:
                     break
                 }
        controller.dismiss(animated: true, completion: nil)
    }
    

}

extension OpenMicViewController : AVAudioRecorderDelegate
{
    
    @IBAction func onclickrecordbutton(_ sender: Any) {
           if isrecording == false {
                isrecording = true
                recordbutton.setBackgroundImage(UIImage(named: "openrecord_active"), for: .normal)
                enablerecordview()
                startRecording()
            } else {
                isrecording = false
                recordbutton.setBackgroundImage(UIImage(named: "openrecord_inactive"), for: .normal)
                enableplayview()
                finishRecording(success: true)
            }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent(filename)
        return path
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(filename)

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
      
        if !flag {
            finishRecording(success: false)
        }
    }
}

extension OpenMicViewController : AVAudioPlayerDelegate{
    
    @IBAction func onclickplaybutton(_ sender: Any) {
        preparePlayer()
        if(isplaying)
        {
            isplaying = false
            playbutton.setImage(UIImage(named: "play_red"), for: .normal)
            audioPlayer.pause()
        }else{
            isplaying = true
            playbutton.setImage(UIImage(named: "pause_red"), for: .normal)
            audioPlayer.play()
        }
        
    }
    
    
    func preparePlayer() {
        var error: NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileURL() as URL)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
            if let err = error {
                print("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 10.0
        }
    }
}

