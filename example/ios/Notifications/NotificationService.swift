//
//  NotificationService.swift
//  Notifications
//
//  Created by Salvatore Giordano on 25/03/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        defer {
            contentHandler(bestAttemptContent ?? request.content)
        }
        print("DID RECEIVE NOTIFICATION")
            // Modify the notification content here...
            bestAttemptContent?.title = "\(bestAttemptContent?.title ?? "<NoContent>") [modified]"
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            contentHandler(bestAttemptContent)
        }
    }

}
