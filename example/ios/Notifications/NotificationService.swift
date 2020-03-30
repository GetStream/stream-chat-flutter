//
//  NotificationService.swift
//  Notifications
//
//  Created by Salvatore Giordano on 25/03/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UserNotifications
import StreamChatCore

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        print("DID RECEIVE")
        
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        defer {
            contentHandler(bestAttemptContent ?? request.content)
        }
        
        let apiKey = "s2dxdhpxd94g"; 
        let userId = "user1"
        let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoidXNlcjEifQ.NGZPyPMx7KSVisJmh4tJhOIv7ZjCaMQpOh4gTINvCaU"
        
        let messageId = bestAttemptContent?.userInfo["message_id"] as! String
        
        print("REQUEST CONTENT \(messageId)")
        
        Client.config = .init(apiKey: apiKey, logOptions: .info)
        Client.shared.set(user: User(id: userId, name: ""), token: token)
        Client.shared.message(with: messageId).subscribe {res in
            print(res)
            Client.shared.disconnect()
        }

        // Modify the notification content here...
        bestAttemptContent?.title = "[modified] \(bestAttemptContent?.title ?? "<NoContent>")"
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
