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
import UserNotifications
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var avPlayer:AVPlayer = AVPlayer()
    var avPlayerItem:AVPlayerItem?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        avPlayer.allowsExternalPlayback = true
        if #available(iOS 13.0, *) {
            self.registerBackgroundTaks()
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        
        
        if UserDefaults.standard.isKeyPresentInUserDefaults(key: UserDefaultKeys.temperature.rawValue)
        {
            
        }else{
            UserDefaults.standard.settemperture(value: false)
            UserDefaults.standard.setmicon(value: true)
            UserDefaults.standard.setnotificationstatus(value: true)
        }
        
        
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
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            UIApplication.shared.beginReceivingRemoteControlEvents()
        }catch{
            print( "testerror",error)
        }
        if #available(iOS 13.0, *) {
            scheduleAppRefresh()
            scheduleImagefetcher()
        } else {
            // Fallback on earlier versions
        }
        
        
        //        UIApplication.shared.runInBackground({
        //
        //        })
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //        do {
        //            if #available(iOS 10.0, *) {
        //                try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
        //                try AVAudioSession.sharedInstance().setActive(true)
        //                UIApplication.shared.beginReceivingRemoteControlEvents()
        //            } else {
        //                // Fallback on earlier versions
        //            }
        //
        //        } catch {
        //            print(error)
        //        }
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
    
    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
        //        NotificationCenter.default.post(name: .opensidebar, object: nil)
    }
    
    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
        NotificationCenter.default.post(name: .opensidebar, object: nil)
    }
    
    private func setviewwhennotificationreceive()
    {
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "burger_menu")
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = 250
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay
        SideMenuController.preferences.animating.transitionAnimator = FadeAnimator.self
        
        
        let mainstoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let sidemenucontroller = SideMenuController()
        let sidemenuvc : MenuController = mainstoryboard.instantiateViewController(withIdentifier: "VC_Menu") as! MenuController
        let alarmvc : AlarmViewController = mainstoryboard.instantiateViewController(withIdentifier: "VC_Alarm") as! AlarmViewController
        let navcontroller = UINavigationController(rootViewController:alarmvc)
        
        sidemenucontroller.delegate = self
        sidemenucontroller.embed(sideViewController: sidemenuvc)
        sidemenucontroller.embed(centerViewController: navcontroller)
        
        window?.rootViewController = sidemenucontroller
    }
}


extension AppDelegate : UNUserNotificationCenterDelegate{
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("user clicked on the notification")
        let userInfo = response.notification.request.content.userInfo
        let targetValue = userInfo["userinfo"] as? String ?? "0"
        
        if targetValue == "0"
        {
            setviewwhennotificationreceive()
        }
        
        completionHandler()
        
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("** willpresent")
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    public func preparePlayer() {
        print("this is enter")
        let urlstring = "http://ethno.fm:8500/ethnofm.mp3"
        let url = NSURL(string: urlstring)
        
        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
                try AVAudioSession.sharedInstance().setActive(true)
                UIApplication.shared.beginReceivingRemoteControlEvents()
                print("AVAudioSession is Active")
                avPlayerItem = AVPlayerItem.init(url: url! as URL)
                avPlayer = AVPlayer.init(playerItem: avPlayerItem)
                avPlayer.volume = 1.0
                NotificationCenter.default.addObserver(self, selector: #selector(onvideoend), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
                avPlayer.play()
            } else {
                // Fallback on earlier versions
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    @objc func onvideoend()
    {
        
    }
}


@available(iOS 13.0, *)
extension AppDelegate{
    private func registerBackgroundTaks() {
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.ethno.imagefetcher", using: nil) { task in
            //This task is cast with processing request (BGProcessingTask)
            self.handleImageFetcherTask(task: task as! BGProcessingTask)
            
        }
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.ethno.apprefresh", using: nil) { task in
            //This task is cast with processing request (BGAppRefreshTask)
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
    }
    
    
    
    
    public func scheduleImagefetcher() {
        
        let request = BGProcessingTaskRequest(identifier: "com.ethno.imagefetcher")
        request.requiresNetworkConnectivity = false // Need to true if your task need to network process. Defaults to false.
        request.requiresExternalPower = false
        //If we keep requiredExternalPower = true then it required device is connected to external power.
        
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60) // fetch Image Count after 1 minute.
        //Note :: EarliestBeginDate should not be set to too far into the future.
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule image fetch: (error)")
        }
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.ethno.apprefresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 2 * 60) // App Refresh after 2 minute.
        //Note :: EarliestBeginDate should not be set to too far into the future.
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: (error)")
        }
    }
    
    func cancelAllPendingBGTask() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        
        task.expirationHandler = {
            
        }
        DispatchQueue.main.async {
            task.setTaskCompleted(success: true)
        }
    }
    
    func handleImageFetcherTask(task: BGProcessingTask) {
        self.scheduleImagefetcher()
        
        //Todo Work
        task.expirationHandler = {
            
        }
        task.setTaskCompleted(success: true)
        
    }
}
