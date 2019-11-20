//
//  UIApplication+Extension.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/4.
//  Copyright © 2019 Ethno. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
 /// Run a block in background after app resigns activity
    public func runInBackground(_ closure: @escaping () -> Void, expirationHandler: (() -> Void)? = nil) {
      DispatchQueue.main.async {
       let taskID: UIBackgroundTaskIdentifier
       if let expirationHandler = expirationHandler {
           taskID = self.beginBackgroundTask(expirationHandler: expirationHandler)
       } else {
           taskID = self.beginBackgroundTask(expirationHandler: { })
       }
      self.endBackgroundTask(taskID)
       closure()

        }
    }
    
  

 }
