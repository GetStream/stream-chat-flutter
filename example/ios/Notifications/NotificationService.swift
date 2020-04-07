//
//  NotificationService.swift
//  Notifications
//
//  Created by Salvatore Giordano on 25/03/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UserNotifications
import StreamChatClient

final class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let sharedDefaults = UserDefaults(suiteName: "group.io.stream.flutter"),
            let apiKey = sharedDefaults.string(forKey: "KEY_API_KEY"),
            let userId = sharedDefaults.string(forKey: "KEY_USER_ID"),
            let token = sharedDefaults.string(forKey: "KEY_TOKEN"),
            let messageId = bestAttemptContent?.userInfo["message_id"] as? String else {
                return
        }
        
        Client.config = .init(apiKey: apiKey, logOptions: .error)
        Client.shared.set(user: User(id: userId), token: token) { res in
            guard res.isConnected else {
                return
            }
            
            Client.shared.message(withId: messageId) { [weak self] res in
                if let message = res.value?.message,
                    let channel = res.value?.channel {
                    let messageWrapper = MessageWrapper(channel: channel, message: message)
                    if let encodedData = try? JSONEncoder.stream.encode(messageWrapper),
                        let encodedString = String(data: encodedData, encoding: .utf8) {
                        let storedMessages = sharedDefaults.stringArray(forKey: "messageQueue") ?? []
                        sharedDefaults.setValue(storedMessages + [encodedString], forKey: "messageQueue")
                        
                        // Modify the notification content here...
                        self.bestAttemptContent?.title = "[modified] \(self?.bestAttemptContent?.title ?? "<NoContent>")"
                        contentHandler(self?.bestAttemptContent ?? request.content)
                    }
                    Client.shared.disconnect()
                }
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}

public struct MessageWrapper: Encodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case channel
        case type
        case user
        case created = "created_at"
        case updated = "updated_at"
        case text
        case command
        case args
        case attachments
        case parentId = "parent_id"
        case showReplyInChannel = "show_in_channel"
        case mentionedUsers = "mentioned_users"
    }
    
    init(channel: Channel, message: Message) {
        id = message.id
        type = message.type
        user = message.user
        created = message.created
        updated = message.updated
        text = message.text
        command = message.command
        args = message.args
        attachments = message.attachments
        parentId = message.parentId
        showReplyInChannel = message.showReplyInChannel
        mentionedUsers = message.mentionedUsers
        extraData = message.extraData
        self.channel = ChannelWrapper(channel: channel)
    }
    
    /// A message id.
    public let id: String
    /// The channel cid.
    public let channel: ChannelWrapper?
    /// A message type (see `MessageType`).
    public let type: MessageType
    /// A user (see `User`).
    public let user: User
    /// A created date.
    public let created: Date
    /// A updated date.
    public let updated: Date
    /// A text.
    public let text: String
    /// A used command name.
    public let command: String?
    /// A used command args.
    public let args: String?
    /// Attachments (see `Attachment`).
    public let attachments: [Attachment]
    /// A parent message id.
    public let parentId: String?
    /// Check if this reply message needs to show in the channel.
    public let showReplyInChannel: Bool
    /// Mentioned users (see `User`).
    public let mentionedUsers: [User]
    /// An extra data for the message.
    public let extraData: Codable?
}

public struct ChannelWrapper: Encodable {
    /// Coding keys for the encoding.
    private enum CodingKeys: String, CodingKey {
        case id
        case cid
        case type
        case name
        case imageURL = "image"
        case members
        case lastMessageDate = "last_message_at"
        case createdBy = "created_by"
        case created = "created_at"
        case deleted = "deleted_at"
        case frozen
    }
    
    init(channel: Channel) {
        id = channel.id
        cid = channel.cid
        type = channel.type
        name = channel.name
        imageURL = channel.imageURL
        lastMessageDate = channel.lastMessageDate
        created = channel.created
        deleted = channel.deleted
        createdBy = channel.createdBy
        config = channel.config
        frozen = channel.frozen
        extraData = channel.extraData
    }
    
    /// A channel id.
    public let id: String
    /// A channel type + id.
    public let cid: ChannelId
    /// A channel type.
    public let type: ChannelType
    /// A channel name.
    public let name: String?
    /// An image of the channel.
    public let imageURL: URL?
    /// The last message date.
    public let lastMessageDate: Date?
    /// A channel created date.
    public let created: Date
    /// A channel deleted date.
    public let deleted: Date?
    /// A creator of the channel.
    public let createdBy: User?
    /// A config.
    public let config: Channel.Config
    /// Checks if the channel is frozen.
    public let frozen: Bool
    /// A list of user ids of the channel members.
    public let members = Set<Member>()
    /// An extra data for the channel.
    public let extraData: Codable?
}
