## 0.2.24+2

- Fix reconnection bug while using tokenProvider

## 0.2.24+1

- Stop ws reconnection after calling disconnect

## 0.2.24

- Create enum for push providers
- Add merge helper functions in `Message` and `ChannelModel` for easier data manipulation

## 0.2.23+3

- Remove + notation from userAgent
- Fix optimistic update for totalUnreadCount

## 0.2.23+2

- Do not throw an error when calling queryChannels without an active connection if the offline storage is enabled

## 0.2.23+1

- Throw an error when calling queryChannels without an active connection
- Wait to establish a connection if calling queryChannels while connecting

## 0.2.23

- Add thread_participants in message model

## 0.2.22

- Add thread-less message reply feature (QuotedMessage)

## 0.2.21+2

- Fix but not throwing error during querychannels and persistance disabled
- Fix reaction.updated event handling

## 0.2.21+1

- Fix error in the offline storage queryChannelCids query

## 0.2.21

- Fix channel.hide(clearHistory: true) not clearing local messages
- Add banned field to member

## 0.2.20

- Return offline data only if the backend is unreachable. This avoids the glitch of  the ChannelListView because we cannot sort by custom properties.

## 0.2.19

- Added message filters for `Client.search()`

## 0.2.18

- Correctly dispose resources when disposing the client state
- Limit parallel queryChannels with same parameters to 1
- Added `clearUser` parameter to `client.disconnect` to remove the user instance of the client

## 0.2.17+1

- Do not retry messages when server returns error 

## 0.2.17

- Add shadow ban feature

## 0.2.16

- Listen for user.updated events

## 0.2.15+2

- Fix reaction score updates

## 0.2.15+1

- Listen to reaction.updated event

## 0.2.15

- Fix search message response

## 0.2.14

- Add event.extradata

## 0.2.13+1

- Let user change channel.extradata if the channel is not initialized yet

## 0.2.13

- Add parent_id to events for typing indicators in threads

## 0.2.12+2

- Fix error with reactions with null user

## 0.2.12

- Do not save channels in memory if not being watched. This was leading to some bugs in some specific use-cases.

## 0.2.11

- Fix user.name getter
- Use detached loggers
- Throw error while connecting if it comes from backend
- Fix ws reconnection

## 0.2.10+2

- Fix bug with event filtering

## 0.2.10+1

- Add default limit to pagination

## 0.2.10

- Added `channel.state.unreadCountStream`

## 0.2.9

- Adding a message on `Channel.update` is now optional

## 0.2.8+1

- Fix retry logic

## 0.2.8

- Add missing event types
- Fix local sorting on offline storage

## 0.2.7+1

- `Client.channel` returns an existing channel if available
- Update message in the offline storage if attachment has expired (for the new CDN)
- Fix `GetMessagesByIdResponse` format
- Do not query messages if already existing in offline storage

## 0.2.6

- Experimental support for Flutter web and MacOs

## 0.2.5+2

- Cleaned up Serialization on extra_data

## 0.2.5+1

- Fix `channel.show` api call

## 0.2.5

- Add `channelType` and `channelId` properties to event object

## 0.2.4+2

- Fix query members messing channel state

## 0.2.4+1

- Do not resync if there is no channel in offlinestorage

## 0.2.4

- Add null-safety to ws disconnect
- Add pagination parameters to queryUsers request

## 0.2.3+3

- Fix reaction add/remove logic

## 0.2.3+2

- Skip system messages during unreadCount computation

## 0.2.3+1

- Removed moor_ffi from dependencies in favor of moor/ffi

## 0.2.3

- Fix reject invite payload

- Add multi-tenant properties to channel and user

## 0.2.2+1

- Fix queryChannels payload

## 0.2.2

- Fix add/remove/invite members api calls

## 0.2.1

- Add `isMutedStream` to `Channel`
- Add `isGroup` to `Channel`
- Add `isDistinct` to `Channel`

## 0.2.0+2

- Fix search messages response class

## 0.2.0+1

- Fix offline members update
- Add channel mutes
- Fix default channel sort

## 0.2.0

- Add `lastMessage` getter to Channel.state
- Add `isSystem` property to Message
- Incremental websocket reconnection timeout
- Add translate message api call
- Add queryMembers api call
- Add user list to client state
- Synchronize channel members status
- Add offline storage
- Add push notifications helper functions

## 0.2.0-alpha+23

- Add `lastMessage` getter to `Channel.state`

## 0.2.0-alpha+22

- Add `isSystem` property to Message

## 0.2.0-alpha+21

- Incremental websocket reconnection timeout

## 0.2.0-alpha+20

- More robust offline storage insertions

## 0.2.0-alpha+19

- Add translate message api call
- Add queryMembers api call

## 0.2.0-alpha+18

- Revert moor_ffi version to 0.5.0

## 0.2.0-alpha+17

- Add user list to client

- Synchronize channel members status

## 0.2.0-alpha+16

- Try QueryChannels when `resync` endpoint returns an error

## 0.2.0-alpha+15

- Fix receiving reactions

## 0.2.0-alpha+14

- Avoid sending local event for optimistic updates

## 0.2.0-alpha+13

- Fix offline on app first start up

## 0.2.0-alpha+12

- Fix retry mechanism in threads
- Fix delete channel query

## 0.2.0-alpha+9

- Add retry mechanism and retry queue

## 0.2.0-alpha+8

- Add copyWith to Attachment

## 0.2.0-alpha+7

- Add channel deleted/updated event handling

## 0.2.0-alpha+6

- Align with stable release

## 0.2.0-alpha+5

- Rename client parameters

## 0.2.0-alpha+3

- Remove dependencies on notification service

- Expose some helping method for integrate offline storage with push notifications

## 0.2.0-alpha+2

- Fix unread count

## 0.2.0-alpha

- Offline storage

- Push notifications

- Minor bug fixes

## 0.1.30

- Add silent property to message

## 0.1.29

- Fix read event handling

## 0.1.28

- Fix bug clearing members when receiving a message

## 0.1.27

- Update dependencies

## 0.1.26

- Remove wrong `members` property from `ChannelModel`

## 0.1.25

- Fix online status

## 0.1.24

- Fix unread count

## 0.1.22

- Add mute/unmute channel

## 0.1.20

- Fix channel query path without id

## 0.1.19

- Fix loading message replies

## 0.1.18

- Export dio error

## 0.1.17

- Ignore current user typing events

- Add event types

## 0.1.16

- Fix message update

## 0.1.15

- Fix mentions handling

## 0.1.14

- Handle message modification and commands

## 0.1.13

- Add message.updated event handling

## 0.1.12

- Add export multipart_file from dio

## 0.1.11

- Add channel config checks

## 0.1.10

- Rename Channel.channelClients to channels

## 0.1.9

- Fix channel update on message delete

## 0.1.8

- Add delete message handling

## 0.1.7

- Add reaction handling

## 0.1.6

- Add initialized completer

- Update example

## 0.1.5

- Add `ClientState` and `ChannelClientState` classes to handle channel state updates using events

- Update example supporting threads

## 0.1.4

- Update some api with wrong or incomplete signatures

- Add documentation for public apis

## 0.1.2

- add websocket reconnection logic

- add token expiration mechanism

## 0.1.1

- add typing events handling

## 0.1.0

- a better example can be found in the example/ directory

- fix some api calls and add missing one

## 0.0.2

- first beta version