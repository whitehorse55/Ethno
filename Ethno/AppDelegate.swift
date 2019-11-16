//
//  AppDelegate.swift
//  Ethno
//
//  Created by Lebron on 1/5/18.
//  Copyright © 2018 Ethno. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SideMenuController
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidBecomeVisibleNotification(notif:)), name: NSNotification.Name("UIWindowDidBecomeVisibleNotification"), object: nil)
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]

       // Replace 'YOUR_APP_ID' with your OneSignal App ID.
       OneSignal.initWithLaunchOptions(launchOptions,
       appId: "78661b30-affd-4dcc-8ec7-f58410250ab2",
       handleNotificationAction: nil,
       settings: onesignalInitSettings)

       OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

       // Recommend moving the below line to prompt for push after informing the user about
       //   how your app will use them.
       OneSignal.promptForPushNotifications(userResponse: { accepted in
           print("User accepted notifications: \(accepted)")
       })
        
        setavplayer()
        configmenubar()
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("enter background", UIApplication.shared.backgroundTimeRemaining)
        
        UIApplication.shared.runInBackground({
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            }catch{
                print( "testerror",error)
            }
        }){
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            }catch{
                print( "testerror",error)
            }
        }
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    

    @objc func windowDidBecomeVisibleNotification(notif: Notification) {
        if let isWindow = notif.object as? UIWindow {
            if (isWindow !== self.window) {
            print("New window did open, check what is the currect URL")
            }
        }
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        let rc = event!.subtype
        print("does this work? \(rc.rawValue)")
    }

}

extension AppDelegate : SideMenuControllerDelegate{
    
    private func configmenubar(){
        
         SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "burger_menu")
         SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
         SideMenuController.preferences.drawing.sidePanelWidth = 250
         SideMenuController.preferences.drawing.centerPanelShadow = true
         SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay
         SideMenuController.preferences.animating.transitionAnimator = FadeAnimator.self
    
        
        let mainstoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let sidemenucontroller = SideMenuController()
        let sidemenuvc : MenuController = mainstoryboard.instantiateViewController(withIdentifier: "VC_Menu") as! MenuController
        let mainvc : MainViewController = mainstoryboard.instantiateViewController(withIdentifier: "VC_Main") as! MainViewController
        let navcontroller = UINavigationController(rootViewController:mainvc)
        
        sidemenucontroller.delegate = self
        sidemenucontroller.embed(sideViewController: sidemenuvc)
        sidemenucontroller.embed(centerViewController: navcontroller)
    
        window?.rootViewController = sidemenucontroller
    }
    
    private func setavplayer(){
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                UIApplication.shared.beginReceivingRemoteControlEvents()
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
//        NotificationCenter.default.post(name: .opensidebar, object: nil)
    }
       
    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
        NotificationCenter.default.post(name: .opensidebar, object: nil)
    }

}

