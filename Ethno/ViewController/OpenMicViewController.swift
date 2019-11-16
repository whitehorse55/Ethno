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

class OpenMicViewController: UIViewController, MFMailComposeViewControllerDelegate {

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer  : AVAudioPlayer!
    
    @IBOutlet weak var recordbutton: UIButton!
    @IBOutlet weak var playbutton: UIButton!
    @IBOutlet weak var sendbutton: UIButton!
    @IBOutlet weak var deletebutton: UIButton!
    
    let filename = "record.m4a"
    var isrecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if( MFMailComposeViewController.canSendMail() ) {
                print("Can send email.")

                let mailComposer = MFMailComposeViewController()
                mailComposer.mailComposeDelegate = self

                //Set the subject and message of the email
                mailComposer.setSubject("Voice Note")
                mailComposer.setMessageBody("my sound", isHTML: false)
                mailComposer.setToRecipients(["zhang19900505@hotmail.com"])

                if let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as? String {
                    let fileManager = FileManager.default
                    let filecontent = fileManager.contents(atPath: docsDir + "/" + filename)
                    mailComposer.addAttachmentData(filecontent!, mimeType: "audio/m4a", fileName: filename)
                }

                self.present(mailComposer, animated: true, completion: nil)
            }
        
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            self.dismiss(animated: true, completion: nil)
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
        audioPlayer.play()
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

extension OpenMicViewController{
    private func setnavigationbuttons()
    {
           self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
           self.navigationController!.navigationBar.shadowImage = UIImage()
           self.navigationController!.navigationBar.isTranslucent = true
           
          let barButtonItem_call = UIBarButtonItem.itemWith(colorfulImage: UIImage(named: "calltostudio") , target:  self, action:  #selector(onclickbarbuttons))
          let barButtonItem_sms = UIBarButtonItem.itemWith(colorfulImage: UIImage(named: "sms"), target:  self ,action:  #selector(onclickbarbuttons))
          let barButtonItem_mic = UIBarButtonItem.itemWith(colorfulImage: UIImage(named: "openmic"), target:  self, action:  #selector(onclickbarbuttons))
          
          let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
          space.width = 20.0
          
          self.navigationController?.addLogoImage(image: UIImage(named: "logo")!, navItem: self.navigationItem)
          navigationItem.rightBarButtonItems = [barButtonItem_call, space, barButtonItem_sms, space, barButtonItem_mic]
    }
          
      @objc func onclickbarbuttons(sender : UIButton)
      {
          
      }
      
      override var prefersStatusBarHidden: Bool{
          return true
      }
}