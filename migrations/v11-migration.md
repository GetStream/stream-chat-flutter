# Stream Chat Flutter SDK v11.0.0 Migration Guide

This guide covers the breaking changes in **Stream Chat Flutter SDK v11.0.0**, where the low-level client moves
onto Stream's OpenAPI-generated API client.

> **Status: in progress.** The version number is provisional until release. This guide is written *as the
> migration happens* — every PR that lands a breaking change appends its entry here, so the guide is complete on
> release day rather than reconstructed from a changelog afterwards. If you are landing such a PR, see
> [Contributing to this guide](#contributing-to-this-guide).

---

## Table of Contents

- [Who Should Read This](#who-should-read-this)
- [What Changed and Why](#what-changed-and-why)
- [Quick Reference](#quick-reference)
- [Symbol Map](#symbol-map)
- [Error Handling](#error-handling)
    - [Endpoints that still throw](#endpoints-that-still-throw)
    - [Logging](#logging)
    - [Anonymous connections identify as `!anon`](#anonymous-connections-identify-as-anon)
    - [Retry behaviour changed](#retry-behaviour-changed)
    - [The error type changed too](#the-error-type-changed-too)
- [Offline Cache](#offline-cache)
- [Feature Areas](#feature-areas)
    - [Sorting](#sorting)
    - [Roles](#roles)
    - [Devices](#devices)
    - [Moderation](#moderation)
    - [App Settings](#app-settings)
    - [Guest Users](#guest-users)
    - [File Upload](#file-upload)
    - [User Groups](#user-groups)
    - [Link Previews](#link-previews)
    - [Partial Updates](#partial-updates)
    - [Channel Lifecycle](#channel-lifecycle)
- [Migration Checklist](#migration-checklist)
- [For AI Agents](#for-ai-agents)
- [Contributing to this guide](#contributing-to-this-guide)

---

## Who Should Read This

| Upgrading From | Sections to Review |
| --- | --- |
| v10.x, using `StreamChatClient` / `Channel` directly | All of it — the API-facing types are what changed |
| v10.x, UI widgets only (`stream_chat_flutter`) | [Error Handling](#error-handling) and any [Feature Area](#feature-areas) whose models you read from `Message`, `Channel`, or `User` |
| v10.x, with a custom `AttachmentFileUploader` | [Feature Areas](#feature-areas) → File Upload |
| v10.x, with `stream_chat_persistence` | [Offline Cache](#offline-cache) — the local database is rebuilt on first launch |
| v10.x, using list controllers without an explicit `sort` | [Feature Areas](#feature-areas) → [Sorting](#sorting) |
| A v11 beta | [Symbol Map](#symbol-map) only — entries are additive across betas |

---

## What Changed and Why

The `stream_chat` package is moving onto a client generated from the same OpenAPI spec that backs our other
SDKs, replacing its hand-written HTTP layer endpoint by endpoint. For you this means:

- **Consistent shapes across Stream products.** A response type in Flutter now matches its counterpart in our
  other SDKs, because both come from one spec.
- **New API surface arrives faster.** Endpoints and fields land by regenerating, not by hand-writing a DTO.
- **Some types were replaced rather than kept.** Where a hand-written type existed only to mirror the wire, the
  generated type takes over. Where our type was the better public API, we kept ours — so this is not a blanket
  rename.

Types under `package:stream_chat/open_api/...` are generated. Treat them as data holders: they are regenerated
from the spec, so don't subclass them or depend on their private constructors.

---

## Quick Reference

| Feature Area | Key Changes |
| --- | --- |
| [**Error Handling**](#error-handling) | Failures carry `stream_core`'s sealed `StreamException` family instead of `StreamChatNetworkError`; `ChatErrorCode` → `StreamErrorCode`. API calls will return `Result<T>` rather than throwing, endpoint by endpoint |
| [**Moderation**](#moderation) | Muting, banning and flagging return a `Result` and call the moderation v2 API; `banUser`'s options map becomes named parameters; `unflagMessage`, `unflagUser` and `removeShadowBan` are removed |
| [**App Settings**](#app-settings) | `getAppSettings` returns a `Result<AppSettingsResponse>` instead of throwing; `GetAppSettingsResponse` is renamed `AppSettingsResponse` |
| [**Guest Users**](#guest-users) | `connectGuestUser` is unchanged; `StreamChatApi.guest` and `ConnectGuestUserResponse` are removed |
| [**File Upload**](#file-upload) | Uploads return a `Result<UploadedFile>` and deletes a `Result<void>` instead of throwing; `AttachmentFileUploaderProvider` receives a `Dio` |
| [**Partial Updates**](#partial-updates) | Channel and member partial updates — `updatePartial`, `updateName`, `updateImage`, slow mode, pin and archive — return a `Result` instead of throwing; their responses take the API's names, `UpdateChannelPartialResponse` and `UpdateMemberPartialResponse`, and `partialMemberUpdate` becomes `updateMemberPartial` |
| [**Channel Lifecycle**](#channel-lifecycle) | Hiding, showing and deleting a channel return a `Result` instead of throwing; stopping watching still throws |
| _(filled in per feature as PRs land)_ | |

---

## Symbol Map

The mechanical part of the upgrade: every renamed, removed, or retyped public symbol. Each row is a
search-and-replace you can apply directly. `Kind` is one of `renamed`, `removed`, `retyped`, `moved`.

| Old symbol | New symbol | Kind | Notes |
| --- | --- | --- | --- |
| `StreamChatNetworkError` | `StreamApiException` (`stream_core`) | `retyped` | Thrown-then-caught becomes `Failure.error`; a sealed family, so `switch` is exhaustive |
| `StreamChatNetworkError.code` / `.message` / `.statusCode` | `StreamApiException.code` / `.message` / `.statusCode` | `moved` | `code` is now a `StreamErrorCode` |
| `StreamChatNetworkError.isRequestCancelledError` | `StreamNetworkException.isCancelled` | `moved` | |
| `StreamChatNetworkError.stackTrace` | `Failure.stackTrace`, or the language at the throw site | `removed` | A `StreamException` carries `message` and `cause` and no trace: a trace records the raise, not the failure |
| `StreamChatNetworkError.type` (`StreamChatNetworkErrorType`) | `StreamNetworkException.isTimeout` / `.isCancelled` | `retyped` | Lossy: `connectionTimeout`, `sendTimeout` and `receiveTimeout` all become `isTimeout` |
| `StreamChatError` | `StreamChatException` | `retyped` | The base of the old tree. `on StreamChatError catch` becomes `on StreamChatException catch`; SDK precondition failures now raise `StreamClientException` |
| `StreamWebSocketError` | `StreamApiException` / `StreamNetworkException` | `retyped` | A refusal the server sent carries the first; a socket that failed on its own carries the second |
| `StreamWebSocketError.isRetriable` | `StreamChatException.isRetriable` | `moved` | Now an extension over the sealed family, so it reads the same on any failure |
| `ChatErrorCode` | `StreamErrorCode` (`stream_core`) | `removed` | Extension type over `int` with named constants. `requestTimeout` was `23`, which the API never returns; the real code is `48` |
| `RetryPolicy.shouldRetry`'s `StreamChatError?` | `StreamChatException?` | `retyped` | |
| `UploadState`'s `Preparing` / `InProgress` / `Success` / `Failed` | `UploadStatePreparing` / `UploadStateInProgress` / `UploadStateSuccess` / `UploadStateFailed` | `renamed` | Frees `Success` for `Result` |
| `PagedValue.error(StreamChatError)` (`stream_chat_flutter_core`) | `PagedValue.error(StreamChatException)` | `retyped` | |
| `StreamChannelListController.muteChannel` / `unmuteChannel` → `Future<void>` (`stream_chat_flutter_core`) | `Future<Result<void>>` | `retyped` | Returns a `Result` instead of throwing, so a `try`/`catch` around either no longer catches a failed call. A subclass overriding one needs the new return type |
| `StreamChannelListController.deleteChannel` → `Future<void>` (`stream_chat_flutter_core`) | `Future<Result<DeleteChannelResponse>>` | `retyped` | Returns a `Result` instead of throwing, so a `try`/`catch` around it no longer catches a failed call. A subclass overriding it needs the new return type |
| `errorBuilder: Function(BuildContext, StreamChatError)` (scroll views) | `Function(BuildContext, StreamChatException)` | `retyped` | |
| `StreamAttachmentValidator.validate()` / `.validateCount()` returning `StreamChatError?` | returning `AttachmentValidationError?` | `retyped` | `stream_chat_flutter`. They always returned rather than threw; the return type now says so |
| `AttachmentLimitReachedError` / `AttachmentTooLargeError` / `AttachmentBlockedError` extending `StreamChatError` | extending `sealed AttachmentValidationError` | `retyped` | A refused attachment is not a failed call, so it is no longer one of the `StreamException` kinds. `switch` over them is exhaustive |
| `Token` | `UserToken` (`stream_core`) | `renamed` | `Token.fromRawValue(x)` → `UserToken(x)`; parses `exp`, so expiry is known |
| `TokenProvider` (typedef `Future<String> Function(String)`) | `TokenProvider` (interface, `stream_core`) | `retyped` | A closure no longer satisfies it. Wrap it: `TokenProvider.dynamic(loader)`, where `typedef UserTokenLoader = Future<UserToken> Function(String userId)` — so the loader returns a `UserToken`, not a `String`, and must be async |
| — | `UserToken(rawJwt)` | `added` | **Throws on a malformed JWT**, where `Token.fromRawValue` accepted anything. It also rejects a token whose `user_id` claim does not match the id it was loaded for. Both present as "cannot log in" rather than as a compile error |
| `TokenManager.loadToken()` / `.isStatic` / `.setTokenOrProvider()` | `.getToken()` / `.usesStaticProvider` / `.setTokenProvider()` | `renamed` | `loadToken(refresh: true)` becomes `expireToken()` then `getToken()` |
| `StreamChatClient.devToken(userId)` | — | `removed` | Generate tokens on your backend |
| `StreamChatClient(logLevel:, logHandlerFunction:)` | `StreamChatClient(logConfig: StreamLogConfig(...))` | `retyped` | Default is unchanged: warnings and errors to the console |
| `StreamChatClient.logger` (a `Logger`) | `StreamChatClient.logger` (a `StreamLogger`) | `retyped` | Messages are lazy: `logger.i(() => '…')` |
| `StreamChatClient.detachedLogger` / `.defaultLogHandler` / `LogHandlerFunction` | — | `removed` | Supply a `StreamLogHandler`; `StreamLogHandler.console()` is the default |
| `export 'package:logging'` (`Logger`, `Level`, `LogRecord`) | `StreamLogger`, `StreamLogConfig`, `StreamLogHandler`, `StreamLogFilter`, `StreamLogPriority`, `StreamLogRecord` | `removed` | `package:logging` is no longer a dependency |
| `StreamChatPersistenceClient(logLevel:, logHandlerFunction:)` | — | `removed` | Logging is configured once, on the client |
| `SortOption<T>.asc(field)` / `.desc(field)` | `ChannelSort.asc(field)` / `MemberSort.desc(field)` / … | `renamed` | One `Sort` subclass per model, as in `stream_feeds`. `nullOrdering` is still a named parameter |
| `SortOption.ASC` / `.DESC` | `SortDirection.asc` / `.desc` | `retyped` | An enum carrying `value` (`1` / `-1`) rather than a bare `int` |
| `const [SortOption.desc(f)]` | `[ChannelSort.desc(f)]` | `retyped` | **Drop the `const`.** A sort list can no longer be `const`: a `SortField` holds a closure that reads the value off the model, which is not a constant expression. Every v10 example wrote `const`, so expect this on the first line you touch |
| `ChannelSortKey` / `MessageSortKey` / `UserSortKey` / … (extension types over `String`) | `ChannelSortField` / `MessageSearchSortField` / `UserSortField` / … | `retyped` | Same member names. A field is no longer a `String`: read `field.remote` for the wire name. `MessageSortKey` is named for its one endpoint: searching |
| `SortOption.desc('my_custom_field')` | `ChannelSort.desc(ChannelSortField.custom('my_custom_field'))` | `retyped` | Only for a field the model does not declare, and only on channel, member, user and message-search sorts — the other queries pin their sort to declared fields and reject a custom one. `custom` reads `extraData`, so pointing it at a declared field sends the right wire name but reads `null` locally — an offline or re-sorted list comes back unordered |
| `SortOrder<T extends ComparableFieldProvider>` | `List<ChannelSort>`, `List<MemberSort>`, … | `removed` | The typedef is gone; signatures name the model's sort type |
| `SortOption.fromJson` | `ChannelSort.fromJson` | `moved` | `Sort` has no `fromJson`: the remote name has to resolve back to a declared field |
| `SortOption(comparator:)` | — | `removed` | Declare a field whose value projects onto something orderable, or sort the list yourself |
| `DraftSortKey`'s `extraData` fallback | — | `removed` | The server rejects a custom sort field on drafts |
| `PollVoteSortKey.answerText` | — | `removed` | The API rejects a sort on `answer_text` |
| a raw-string sort on `language` | `UserSortField.language` | `added` | Declared now, so prefer it over `UserSortField.custom('language')`, which reads `extraData` and never sees a typed property |
| a raw-string sort on `updated_at` for members | `MemberSortField.updatedAt` | `added` | Same: prefer the declared field over `.custom` |
| a raw-string sort on `text` / `type` / `parent_id` / `reply_count` / `pinned` | `MessageSearchSortField.text` / `.type` / `.parentId` / `.replyCount` / `.pinned` | `added` | The fields the JS client already exposed |
| _(new)_ | `ChannelSortField.cid` | `added` | Both iOS and Android sort channels by `cid` |
| _(new)_ | `MessageReminderSortField.messageId` | `added` | The server allows it and breaks reminder ties on it |
| _(new)_ | `MessageSearchSortField.relevance` | `added` | Sorts search results by match quality; the server drops it when the request has no text filter |
| `defaultChannelListSort` / `defaultMemberListSort` / `defaultUserListSort` / `defaultDraftListSort` / `defaultMessageReminderListSort` / `defaultPollVoteListSort` (`stream_chat_flutter_core`) | `ChannelSort.defaultSort` / `MemberSort.defaultSort` / … (`stream_chat`) | `moved` | The default belongs to the sort, as in `stream_feeds` and on Android. Now reachable without the Flutter layer |
| `StreamChannelListController(channelStateSort: null)` and the other controllers' `sort: null` | omit the argument, or pass `ChannelSort.empty` | `retyped` | A controller's `sort` is non-nullable where the model declares a default. Omitting it applies that default; `XSort.empty` queries with the ordering the API applies on its own and leaves the page in the order it arrived in |
| `ComparableField` / `ComparableFieldProvider` | — | `removed` | Never exported. A field now carries its own extractor, passed to `XSortField(remote, localValue)`; there is no public getter for the value it reads, so assert on the ordering a sort produces rather than on the value behind it |
| `getComparableField(String)` on `User`, `Message`, `Member`, `Draft`, `Thread`, `Poll`, `PollVote`, `Reaction`, `BannedUser`, `MessageReminder` and `ChannelState` | — | `removed` | The types it named were unexported, but the method was public on all eleven models. A field reads its own value now, so an override has nowhere to go |
| `NullOrdering` / `CompositeComparator` | `stream_core`'s, re-exported | `moved` | Same names and semantics |
| `client.search(sort:)` / `channel.search(sort:)` / `StreamMessageSearchListController.sort`, taking `SortOrder?` | `List<MessageSearchSort>?` | `retyped` | Was untyped, so a channel field compiled — and the server does not reject one, it reads it as a custom message field, which is null on every message, so the term silently did nothing |
| `Filter.equal('type', 'messaging')` | `ChannelFilter.equal(ChannelFilterField.type, 'messaging')` | `retyped` | One `Filter` alias and one field registry per query, as with sort and as in `stream_feeds` |
| `Filter` (`key`, `value`, `operator`) | `stream_core`'s sealed `Filter<T>` | `retyped` | The parts are gone; read the filter with `toJson()` |
| `Filter` value equality | — | `removed` | It was `Equatable`; core's compares by identity. Compare `toJson()` |
| `FilterOperator` (enum) | `FilterOperator` (extension type over `String`) | `retyped` | `'$eq'` and `FilterOperator.equal` interchange |
| `Filter.empty()` | `null` | `removed` | Every `filter` argument is nullable. `queryThreads` widens for an omitted filter but not an empty one, so the two are not the same request |
| `Filter.notEqual` / `Filter.notIn` / `Filter.nor` | — | `removed` | `$ne`, `$nin` and `$nor` are deprecated server-side and are being withdrawn. Drop the rows from the result instead, as the iOS and React Native sample apps do |
| `Filter.notExists(key)` | `Filter.exists(field, exists: false)` | `renamed` | One operator with a flag, matching the wire shape |
| `Filter.custom(value:, operator:, key:)` | `XFilterField.custom(remote)` or `Filter.raw` | `removed` | A field the SDK does not model, versus a query it cannot express |
| `Filter.raw(value: {...})` | `Filter.raw({...})` | `retyped` | Positional. Not validated, and `matches` throws for it |
| `queryChannels(filter:)`, `queryUsers(filter:)`, `queryMembers(filter:)`, … taking `Filter?` | `ChannelFilter?`, `UserFilter?`, `MemberFilter?`, … | `retyped` | A field from another model no longer compiles |
| `ChatPersistenceClient` filter arguments | `ChannelFilter?` | `retyped` | `getChannelStates`, `queryChannelStates`, `updateChannelQueries`, `saveChannelQueries` |
| _(new)_ | `ChannelFilterField.members` / `.memberUserName` | `added` | Keeps the standard "channels I am in" query typed |
| _(new)_ | `ChannelModel.muted` / `.blocked`, `Channel.blocked` / `.blockedStream` | `added` | Already on the channel payload; now read without reaching into extra data |
| `LocationCoordinates` | `LocationCoordinate` | `renamed` | `stream_core`'s, re-exported. Singular, since it is one point |
| `LocationCoordinates.copyWith` | — | `removed` | Two required doubles; construct a new one |
| `LocationCoordinates` exact equality | `LocationCoordinate` equality within ~1cm | `retyped` | Compares to a 1e-7 epsilon, so coordinates that round-trip through the API still match |
| _(new)_ | `LocationCoordinate.distanceTo` | `added` | Haversine distance, returning a `Distance` |
| `SortedListX` / `IterableMergeX` / `ListX` | `SortedListExtensions` (`stream_core`) | `moved` | Re-exported from this package. One extension where there were three, so a call site that used two of them needs no extra import |
| `mergeSorted` | `sortedMerge` | `renamed` | A key held twice now collapses to the last element carrying it, as `merge` does, rather than being carried through |
| `updateIf(test, update)` | `updateWhere(test, update: update)` | `renamed` | The second argument is named |
| `mergeFrom(other, key:, value:)` | `merge(other.map(value).nonNulls, key:)` | `removed` | Project first, then merge |
| `StreamMessageSearchListController.filter` / `.messageFilter` (both `Filter`) | `ChannelFilter` / `MessageSearchFilter?` | `retyped` | Two registries on one controller: `filter` narrows the channels searched, `messageFilter` the messages. Fields for the latter are `MessageSearchFilterField` — `ChannelFilterField` has no `text` |
| `Result` (`package:async`, via this barrel) | `Result` (`stream_core`) | `retyped` | A different type under the same name. `package:async` is still re-exported, but with `Result` hidden |
| `CurrentPlatform` / `PlatformType` (`stream_chat`) | `CurrentPlatform` / `PlatformType` (`stream_core`) | `moved` | Re-exported from this package. Same seven platforms and the same strings |
| `CurrentPlatform.name` | `CurrentPlatform.operatingSystem` | `renamed` | Same value — `'android'`, `'ios'`, `'web'`, `'macos'`, … |
| `client.wsConnectionStatus` / `.wsConnectionStatusStream` | `client.connectionStatus` / `.connectionStatusStream` | `renamed` | Same `ConnectionStatus`, same three values. The WebSocket's own state, and the disconnection sources it carries, are no longer exported: `ConnectionStatus` is the whole connection API, as on the other Stream SDKs |
| `StreamChatClient.searchRoles` → `Future<SearchRolesResponse>` | `Future<Result<SearchRolesResponse>>` | `retyped` | Returns a `Result` instead of throwing |
| `StreamChatClient.addDevice` / `removeDevice` → `Future<EmptyResponse>` | `Future<Result<void>>` | `retyped` | Returns a `Result` instead of throwing, and carries no value on success |
| `StreamChatClient.getDevices` → `Future<ListDevicesResponse>` | `Future<Result<ListDevicesResponse>>` | `retyped` | Returns a `Result` instead of throwing |
| `StreamChatClient.muteUser` → `Future<EmptyResponse>` | `Future<Result<void>>` | `retyped` | Returns a `Result` instead of throwing, and carries no value |
| — | `muteUser(timeout:)` | `added` | Expires the mute after that long. v10 took only the user id |
| — | `moderation.muteUsers` / `unmuteUsers` | `added` | Mute or unmute several users in one call. `MuteUsersResponse.nonExistingUsers` names the ids that matched no user; the single-id methods carry no value, because a call where no id matches fails instead |
| `StreamChatClient.unmuteUser` → `Future<EmptyResponse>` | `Future<Result<void>>` | `retyped` | Same |
| `StreamChatClient.muteChannel` / `unmuteChannel` → `Future<EmptyResponse>` | `Future<Result<void>>` | `retyped` | Returns a `Result` instead of throwing, and carries no value on success |
| `StreamChatClient.flagMessage` / `flagUser` → `Future<EmptyResponse>` | `Future<Result<FlagResponse>>` | `retyped` | Plus optional `reason` and `custom` arguments. `FlagResponse.itemId` identifies the review queue item |
| `StreamChatClient.banUser(id, Map options)` | `banUser(id, {channelCid, timeout, reason, shadow, ipBan, deleteMessages})` | `retyped` | Named parameters mirroring the endpoint's options. `timeout` is a `Duration` applied with minute granularity |
| `StreamChatClient.unbanUser(id, Map options)` | `unbanUser(id, {channelCid})` | `retyped` | `remove_future_channels_ban` and `reason` are gone — the moderation v2 unban endpoint has neither |
| `StreamChatClient.shadowBan(id, Map options)` | `shadowBan(id, {channelCid, timeout, reason, ipBan, deleteMessages})` | `retyped` | Same options as `banUser`, minus `shadow` |
| `StreamChatClient.removeShadowBan` / `Channel.removeShadowBan` | `moderation.unbanUser` / `Channel.unbanMember` | `removed` | It sent `shadow: true` to unban, which no version of that endpoint reads, so it always did what `unbanUser` does |
| `StreamChatClient.unflagMessage` / `unflagUser` | — | `removed` | `POST /moderation/unflag` has no v2 endpoint and the v1 one removed no flag |
| `Channel.banMember(id, Map options)` / `shadowBan(id, Map options)` | `banMember(id, {timeout, reason, shadow, ipBan, deleteMessages})` / `shadowBan(id, {…})` | `retyped` | The channel supplies its own `channelCid`; the `type` + `id` pair it used to send is deprecated server-side |
| `Channel.mute` / `unmute` / `unbanMember` → `Future<EmptyResponse>` | `Future<Result<void>>` | `retyped` | Returns a `Result` instead of throwing |
| — | `MuteUsersResponse` / `UnmuteUsersResponse` / `FlagResponse` | `added` | What the mute, unmute and flag calls answer with |
| — | `DeleteType` | `added` | Extension type over `String` with `soft` / `pruning` / `hard`, for `banUser(deleteMessages:)`. A value it does not name still carries: `DeleteType('...')` |
| `StreamChatClient.muteUser` / `unmuteUser` / `muteChannel` / `unmuteChannel` / `banUser` / `unbanUser` / `shadowBan` / `flagMessage` / `flagUser` | `StreamChatClient.moderation.<same name>` | `moved` | Grouped onto a `ModerationClient`. `Channel`'s moderation methods keep their place |
| `Device.fromJson` / `toJson`, `Role.fromJson` | — | `removed` | The models are plain classes; construct them directly |
| `PushProvider` (enum), `Device.pushProvider` (`String`) | `PushProvider` (extension type over `String`), `Device.pushProvider` (`PushProvider`) | `retyped` | Same four constants and wire values, and still usable as a `String`. `.name` and `.values` are gone and a `switch` over it needs a default; wrap a raw value as `PushProvider('firebase')` |
| `ListDevicesResponse.fromJson`, `SearchRolesResponse.fromJson`, `ListDevicesResponse()..devices = …` | `ListDevicesResponse(duration: …, devices: …)` | `retyped` | The responses are plain classes with a const constructor and final fields |
| `ListDevicesResponse.duration` / `SearchRolesResponse.duration` (`String?`) | `String` | `retyped` | Always present; drop any `!` or `?? ''` |
| `Device` / `ListDevicesResponse` / `SearchRolesResponse` identity `==` | value `==`, plus `copyWith` | `retyped` | Two instances with the same fields are now equal |
| `Role extends Equatable`, `Role.props` | `Role` (value `==`, `copyWith`) | `removed` | Equality is unchanged; `props` is gone and `Role` is no longer an `Equatable` |
| `StreamChatApi.device` | `StreamChatApi.pushPreferences` | `renamed` | The class handles only `setPushPreferences` now; device calls moved to the generated client |
| `StreamChatClient.listUserGroups` / `searchUserGroups` / `getUserGroup` / `createUserGroup` / `updateUserGroup` / `addUserGroupMembers` / `removeUserGroupMembers` → `Future<XResponse>` | `Future<Result<XResponse>>` | `retyped` | Returns a `Result` instead of throwing |
| `StreamChatClient.deleteUserGroup` → `Future<EmptyResponse>` | `Future<Result<void>>` | `retyped` | Returns a `Result` instead of throwing, and carries no value on success |
| `UserGroup.fromJson` / `toJson`, `UserGroupMember.fromJson` / `toJson`, the user group responses' `fromJson` | — | `removed` | The models are plain classes; construct them directly. `fromData` / `toData` are the offline database's format, not API JSON |
| `ListUserGroupsResponse()..userGroups = …` and the other user group responses' `late` setters | `ListUserGroupsResponse(duration: …, userGroups: …)` | `retyped` | The responses are plain classes with a const constructor and final fields |
| The user group responses' `duration` (`String?`) | `String` | `retyped` | Always present; drop any `!` or `?? ''` |
| `GetUserGroupResponse` / `CreateUserGroupResponse` / `UpdateUserGroupResponse` / `AddUserGroupMembersResponse` / `RemoveUserGroupMembersResponse`.`userGroup` (`UserGroup`) | `UserGroup?` | `retyped` | The API does not guarantee the group in the response; handle `null` |
| `UserGroup` / `UserGroupMember extends Equatable`, `.props` | value `==`, plus `copyWith` | `removed` | Equality is unchanged; `props` is gone |
| The user group responses' identity `==` | value `==`, plus `copyWith` | `retyped` | Two instances with the same fields are now equal |
| `StreamChatApi.userGroups` | `StreamChatClient` user group methods | `removed` | The endpoints moved to the generated client |
| `StreamChatClient.enrichUrl` → `Future<OGAttachmentResponse>` | `Future<Result<OGAttachmentResponse>>` | `retyped` | Returns a `Result` instead of throwing |
| `OGAttachmentResponse.fromJson` | — | `removed` | The response is a plain class; construct it directly |
| `OGAttachmentResponse()..ogScrapeUrl = …` and its other setters | `OGAttachmentResponse(duration: …, ogScrapeUrl: …)` | `retyped` | A plain class with a const constructor and final fields |
| `OGAttachmentResponse.duration` (`String?`) | `String` | `retyped` | Always present; drop any `!` or `?? ''` |
| `OGAttachmentResponse` identity `==` | value `==`, plus `copyWith` | `retyped` | Two instances with the same fields are now equal |
| `StreamChatApi.general.enrichUrl` | `StreamChatClient.enrichUrl` | `removed` | The endpoint moved to the generated client |
| `StreamChatClient.getAppSettings` → `Future<AppSettings>` | `Future<Result<AppSettingsResponse>>` | `retyped` | Returns a `Result` instead of throwing, and answers the whole response: read the settings off `.app`. `client.appSettings` is unchanged |
| `GetAppSettingsResponse` | `AppSettingsResponse` | `renamed` | Same fields: `duration` and `app` |
| `AppSettings.fromJson`, `UploadConfig.fromJson` | — | `removed` | The models are plain classes; construct them directly |
| `GetAppSettingsResponse.fromJson`, `GetAppSettingsResponse()..app = …` | `AppSettingsResponse(duration: …, app: …)` | `retyped` | The response is a plain class with a const constructor and final fields |
| `GetAppSettingsResponse.duration` (`String?`) | `String` | `retyped` | Always present; drop any `!` or `?? ''` |
| `GetAppSettingsResponse` identity `==` | value `==`, plus `copyWith` | `retyped` | Two instances with the same fields are now equal |
| `AppSettings extends Equatable` / `UploadConfig extends Equatable`, `props` | `AppSettings` / `UploadConfig` (value `==`, `copyWith`) | `removed` | Equality is unchanged; `props` is gone and neither is an `Equatable` any more |
| `StreamChatApi.general.getAppSettings()` | `StreamChatClient.getAppSettings()` | `removed` | The call moved to the generated client |
| `StreamChatApi.guest` (`GuestApi.getGuestUser`) | `StreamChatClient.connectGuestUser` | `removed` | The call moved to the generated client; `connectGuestUser` keeps its signature and still throws |
| `ConnectGuestUserResponse` | — | `removed` | Only `StreamChatApi.guest` returned it; `connectGuestUser` still returns the connected `OwnUser` |
| `sendImage` / `sendFile` / `uploadImage` / `uploadFile` → `Future<SendImageResponse>` and siblings | `Future<Result<UploadedFile>>` | `retyped` | On `StreamChatClient`, `Channel` and `AttachmentFileUploader`. Returns a `Result` instead of throwing |
| `deleteImage` / `deleteFile` / `removeImage` / `removeFile` → `Future<EmptyResponse>` | `Future<Result<void>>` | `retyped` | On `StreamChatClient`, `Channel` and `AttachmentFileUploader`. Returns a `Result` instead of throwing |
| `SendAttachmentResponse`, `SendFileResponse`, `SendImageResponse`, `UploadImageResponse`, `UploadFileResponse` | `UploadedFile` (`stream_core`) | `removed` | `.file` becomes `.fileUrl`; `.thumbUrl` is unchanged; `duration` is gone |
| `AttachmentFileUploaderProvider` = `AttachmentFileUploader Function(StreamHttpClient)` | `AttachmentFileUploader Function(Dio)` | `retyped` | Receives the client's `Dio`; `StreamAttachmentFileUploader(dio)` builds the default |
| `StreamChatApi.fileUploader`, `StreamChatApi(attachmentFileUploaderProvider:)` | `StreamChatClient(attachmentFileUploaderProvider:)` | `removed` | The uploader belongs to `StreamChatClient` |
| `PartialUpdateChannelResponse` | `UpdateChannelPartialResponse` | `renamed` | The name of the API's response. Same fields: `duration`, `channel` and `members` |
| `PartialUpdateMemberResponse` | `UpdateMemberPartialResponse` | `renamed` | The name of the API's response. Same fields: `duration` and `channelMember` |
| `StreamChatClient.partialMemberUpdate` | `StreamChatClient.updateMemberPartial` | `renamed` | The name of the API's operation, matching `updateChannelPartial` |
| `StreamChatClient.enableSlowdown` / `disableSlowdown` | `StreamChatClient.enableSlowMode` / `disableSlowMode` | `renamed` | Matches `Channel.enableSlowMode` / `disableSlowMode` and `ChannelCapability.slowMode` |
| `StreamChatClient.updateChannelPartial` / `enableSlowdown` / `disableSlowdown` → `Future<PartialUpdateChannelResponse>` | `updateChannelPartial` / `enableSlowMode` / `disableSlowMode` → `Future<Result<UpdateChannelPartialResponse>>` | `retyped` | Returns a `Result` instead of throwing |
| `Channel.updatePartial` / `updateName` / `updateImage` / `enableSlowMode` / `disableSlowMode` → `Future<PartialUpdateChannelResponse>` | `Future<Result<UpdateChannelPartialResponse>>` | `retyped` | Returns a `Result` instead of throwing. Calling one before the channel is initialized still throws a `StateError` |
| `StreamChatClient.partialMemberUpdate` / `pinChannel` / `unpinChannel` / `archiveChannel` / `unarchiveChannel` → `Future<PartialUpdateMemberResponse>` | `Future<Result<UpdateMemberPartialResponse>>` | `retyped` | Returns a `Result` instead of throwing |
| `Channel.pin` → `Future<Member>`, `unpin` / `archive` / `unarchive` → `Future<Member?>` | `Future<Result<UpdateMemberPartialResponse>>` | `retyped` | Returns a `Result` instead of throwing, and answers the whole response: read the member off `.channelMember`. Calling one before the channel is initialized still throws a `StateError` |
| `PartialUpdateChannelResponse.channel` (`ChannelModel`) | `UpdateChannelPartialResponse.channel` (`ChannelModel?`) | `retyped` | Nullable, as the API declares it |
| `PartialUpdateChannelResponse.members` (`List<Member>?`) | `UpdateChannelPartialResponse.members` (`List<Member>`) | `retyped` | Always present, empty when the channel has no members; drop any `?.` or `?? []` |
| `PartialUpdateMemberResponse.channelMember` (`Member`) | `UpdateMemberPartialResponse.channelMember` (`Member?`) | `retyped` | Nullable, as the API declares it |
| `PartialUpdateChannelResponse.duration` / `PartialUpdateMemberResponse.duration` (`String?`) | `String` | `retyped` | Always present; drop any `!` or `?? ''` |
| `PartialUpdateChannelResponse.fromJson` / `PartialUpdateMemberResponse.fromJson` | — | `removed` | The responses are plain classes; construct them directly |
| `PartialUpdateChannelResponse()..channel = …`, `PartialUpdateMemberResponse()..channelMember = …` and their other setters | `UpdateChannelPartialResponse(duration: …, channel: …)` / `UpdateMemberPartialResponse(duration: …, channelMember: …)` | `retyped` | Plain classes with a const constructor and final fields |
| `PartialUpdateChannelResponse` / `PartialUpdateMemberResponse` identity `==` | value `==`, plus `copyWith` | `retyped` | Two instances with the same fields are now equal |
| `StreamChatApi.channel.updateChannelPartial` / `enableSlowdown` / `disableSlowdown` / `updateMemberPartial` | the `StreamChatClient` methods | `removed` | The endpoints moved to the generated client |
| `StreamChatClient.hideChannel` / `showChannel` / `deleteChannel` → `Future<EmptyResponse>` | `Future<Result<HideChannelResponse>>` / `Future<Result<ShowChannelResponse>>` / `Future<Result<DeleteChannelResponse>>` | `retyped` | Returns a `Result` instead of throwing |
| `Channel.hide` / `show` / `delete` → `Future<EmptyResponse>` | `Future<Result<HideChannelResponse>>` / `Future<Result<ShowChannelResponse>>` / `Future<Result<DeleteChannelResponse>>` | `retyped` | Returns a `Result` instead of throwing. Calling one before the channel is initialized still throws a `StateError` |
| `StreamChatApi.channel.hideChannel` / `showChannel` / `deleteChannel` | the `StreamChatClient` methods | `removed` | The endpoints moved to the generated client |
| `MemberUpdatePayload(pinned: true).toJson()` / `MemberUpdateType.pinned.name` | `{'pinned': true}` / `'pinned'` | `removed` | Same for `archived`. Or call `pinChannel` / `unpinChannel` / `archiveChannel` / `unarchiveChannel` |
| _(more added per feature as PRs land)_ | | | |

---

## Error Handling

**This is the change that will touch every call site.** API methods will return a `Result<T>` instead of
throwing, matching the `stream_feeds` SDK. That conversion lands endpoint by endpoint, so what an endpoint does
today depends on whether it has moved — and for every endpoint that has not, the *type* of failure it throws has
changed regardless.

**Before:**
```dart
try {
  final response = await client.queryChannels(filter: filter).first;
  print(response);
} on StreamChatNetworkError catch (error) {
  print(error.message);
}
```

**After**, once the endpoint you are calling has moved — the shape, not a call you can make today:
```dart
final result = await client.someMigratedCall();

result.fold(
  onSuccess: (response) => print(response),
  onFailure: (error, stackTrace) => print(error),
);
```

`Result<T>` is a sealed type with `Success<T>` and `Failure`, exported from `package:stream_chat/stream_chat.dart`.
Besides `fold` it offers `getOrThrow()`, `getOrNull()`, `getOrElse(...)`, `exceptionOrNull()`, `map(...)` and
`flatMap(...)`.

If you want the old behaviour at a call site while you migrate incrementally, `getOrThrow()` rethrows the
underlying error:

```dart
final response = (await client.someMigratedCall()).getOrThrow();
```

### Endpoints that still throw

`Result` arrives feature by feature. Until a given endpoint has migrated it still **throws** — but it throws a
`StreamChatException` now, not a `StreamChatNetworkError`. So during the v11 betas both call styles are live, and
both report the same four kinds:

```dart
// A migrated endpoint returns a Result.
final result = await client.someMigratedCall();

// One that has not migrated still throws — the type is what changed.
try {
  await channel.sendMessage(message);
} on StreamChatException catch (error) {
  print(error.message);
}
```

`StreamChatException` is an alias of `stream_core`'s `StreamException`, so either name catches the same failures.

**Reading `.code` or `.statusCode` means catching a subtype — and that narrows what you catch.** The
tempting one-for-one swap silently stops handling most failures:

```dart
// ✗ compiles, and no longer catches timeouts, cancellation, auth failures or
//   a response the SDK could not decode.
} on StreamApiException catch (e) {
  if (e.statusCode == 429) backOff();
}

// ✓ catch the root, then match. `StreamChatException` is sealed, so this
//   `switch` is exhaustive with no default arm.
} on StreamChatException catch (e) {
  switch (e) {
    case StreamApiException(:final statusCode) when statusCode == 429: backOff();
    case StreamNetworkException(isTimeout: true): retryLater();
    case StreamAuthenticationException(): reauthenticate();
    case StreamClientException(): rethrow;   // an SDK bug, not yours
    case StreamApiException(): showError(e.message);
    case StreamNetworkException(): showOffline();
  }
}
```

Note this differs from the `Result.fold` example further down: `Failure.error` is typed `Object`, so
a `switch` on it *does* need a default arm. Only the caught root is sealed.

> **The old error types are deleted, not deprecated.** `StreamChatError`, `StreamChatNetworkError`,
> `StreamChatNetworkErrorType` and `StreamWebSocketError` are gone. This is deliberate: a deprecated
> `StreamChatNetworkError` would leave `on StreamChatNetworkError catch (e)` compiling while silently matching
> nothing, so a failure you used to handle would pass straight through at runtime. Deleting the type turns that
> into a compile error instead. Replace each one with `StreamChatException`, or with the specific kind you care
> about — see the Symbol Map for the row-by-row mapping.

### Logging

One `logConfig` replaces the two logging parameters, and records are `stream_core`'s:

**Before:**
```dart
final client = StreamChatClient(
  apiKey,
  logLevel: Level.INFO,
  logHandlerFunction: (LogRecord record) => myTracker.log(record.message),
);
```

**After:**
```dart
class MyHandler extends StreamLogHandler {
  const MyHandler();

  @override
  void handle(StreamLogRecord record) => myTracker.log(record.message);
}

final client = StreamChatClient(
  apiKey,
  logConfig: const StreamLogConfig(
    priority: StreamLogPriority.info,
    handler: MyHandler(),
  ),
);
```

Leave `logConfig` out and nothing changes from before: warnings and errors go to the console.

Records carry a `tag` naming the subsystem — `SCh:Ws`, `SCh:Http`, `SCh:RetryQueue` — and
`StreamLogFilter.prefix` filters on it, so you can turn one subsystem up without the rest. The
handler is process-global across Stream SDKs, which is why the tags are prefixed per product.

`StreamChatPersistenceClient` no longer takes logging parameters at all; it writes through the same
logger.

### Anonymous connections identify as `!anon`

`connectAnonymousUser` previously sent a client-generated random `user_id`; it now sends `!anon`, which is the id
the backend reserves for anonymous access and what our other SDKs send. `client.state.currentUser.id` reflects it.
If you keyed anything off that random id, it is no longer random.

### Retry behaviour changed

If you rely on the SDK's automatic retry of failed messages, it now retries more: a request that never reached the
server, a 5xx, a 429 and a 408. It still never retries another 4xx, a cancelled request, broken credentials, or
anything the server marked `unrecoverable`. Previously only failures *without* a parseable error body retried, so a
500 and a 429 did not. A custom `RetryPolicy.shouldRetry` overrides this, and `error.isRetriable` gives you the
default decision.

### The error type changed too

`Failure.error` is statically typed `Object`, and at runtime it is always a `StreamException` from `stream_core` —
**not** a `StreamChatNetworkError`. Chat now uses the same error types as our other SDKs:

| Type | When | Carries |
| --- | --- | --- |
| `StreamApiException` | the API answered with an error | `statusCode`, `code`, `moreInfo`, `unrecoverable`, `retryAfter`, `apiError` |
| `StreamNetworkException` | transport failed | `isCancelled`, `isTimeout`, `closeCode` |
| `StreamAuthenticationException` | the token was refused | — |
| `StreamClientException` | an SDK bug, or a response body that would not decode | the original error as `cause` |

```dart
result.fold(
  onSuccess: (response) => print(response.devices),
  onFailure: (error, stackTrace) => switch (error) {
    StreamApiException(:final code, :final message, :final statusCode) =>
      print('$code: $message ($statusCode)'),
    StreamNetworkException(isCancelled: true) => null,          // user cancelled
    final StreamException e => print(e.message),
    _ => print('unexpected: $error'),
  },
);
```

It is a sealed family, so a `switch` over it is exhaustive. Everything you read off `StreamChatNetworkError` has a
counterpart: `code` is now a `StreamErrorCode` (an extension type over `int`, with named constants like
`rateLimited` and `inputError`), `statusCode` and `message` are unchanged in spirit, and
`isRequestCancelledError` becomes `StreamNetworkException.isCancelled`.

`StreamApiException` exposes `isTokenExpired`, `isTokenNotYetValid`, `isTokenSignatureInvalid`,
`isApiKeyInvalid` and `isRateLimited` directly, so the common checks need no code of your own.

`ChatErrorCode` is removed — use `StreamErrorCode`. One value differed from the API: `requestTimeout` was `23`, a code the backend never returns, so anything matching on it never matched. The real code is `48`.

`Result` and the `StreamException` family are exported from `package:stream_chat/stream_chat.dart`.

---

## Offline Cache

If you use `stream_chat_persistence`, the local database is **rebuilt from empty** the first time your app runs
on v11. The Drift schema version moves from `1036` to `1104`, and the upgrade strategy drops and recreates every
table rather than migrating rows.

Everything held on disk is discarded: channels, messages, members, reads, drafts, locations, polls, poll votes
and reactions. **Messages that failed or were queued while offline are stored in the same table**, so they go
too, and they are not re-sent. Anything already synced comes back on the next query; anything that never reached
the server does not.

No code changes for this, but plan for one cold start: the first channel list and the first message list after
upgrading are network reads, not cache reads.

---

## Feature Areas

_Each migrated feature gets a section here. Sections are added by the PR that migrates the feature, using the
template in [Contributing to this guide](#contributing-to-this-guide)._

### Sorting

**`sort: null` no longer suppresses sorting.** A list controller used to default the argument, so passing
`null` explicitly sent no sort and let the server order the result. Its `sort` is non-nullable now: leaving the
argument out applies the model's default, and `XSort.empty` is what sends no sort.

```dart
// v10 — sends no sort, server ordering.
StreamUserListController(client: client, sort: null);

// v11 — sends no sort, server ordering.
StreamUserListController(client: client, sort: UserSort.empty);

// v11 — sends UserSort.defaultSort.
StreamUserListController(client: client);
```

This applies to the user, member, draft, poll-vote, message-reminder and channel controllers.
`StreamThreadListController`, `StreamReactionListController` and `StreamMessageSearchListController` declare no
default and still send nothing unless given a sort.

An empty sort also leaves a loaded page in the order it arrived in, rather than re-sorting it — including a page
read from the offline cache, which orders by the model's default when the query named no sort.

### Roles

**`searchRoles` returns a `Result` instead of throwing.** `Role` and `SearchRolesResponse` keep their
fields.

```dart
// v10
try {
  final response = await client.searchRoles('admin');
  useRoles(response.roles);
} on StreamChatException catch (e) {
  report(e);
}

// v11
final result = await client.searchRoles('admin');
result.fold(
  onSuccess: (response) => useRoles(response.roles),
  onFailure: (error, _) => report(error),
);
```

`getOrDefault`, `getOrNull` and `map` are available when you only want the happy path — see
[Error Handling](#error-handling) for the full `Result` surface.

**`Role` and `SearchRolesResponse` no longer decode JSON.** Both are plain classes; build them with their
constructors, for example in a test stub:

```dart
// v10
final response = SearchRolesResponse()..roles = [role];

// v11
final response = SearchRolesResponse(duration: '0ms', roles: [role]);
```

**`SearchRolesResponse.duration` is a non-nullable `String`**, where v10 typed it `String?`.

### Devices

**`addDevice`, `getDevices` and `removeDevice` return a `Result` instead of throwing.** `addDevice` and
`removeDevice` carry no value on success. `Device` and `ListDevicesResponse` keep their fields.

```dart
// v10
try {
  await client.addDevice(token, PushProvider.firebase);
} on StreamChatException catch (e) {
  report(e);
}

// v11
final result = await client.addDevice(token, PushProvider.firebase);
result.fold(
  onSuccess: (_) => registered(),
  onFailure: (error, _) => report(error),
);
```

**`Device` and `ListDevicesResponse` no longer decode JSON.** Both are plain classes; build them with their
constructors — `ListDevicesResponse(duration: '0ms', devices: [device])` where v10 wrote
`ListDevicesResponse()..devices = [device]`. `OwnUser.devices` still decodes from, and encodes to, the same
`id` and `push_provider` keys.

**`ListDevicesResponse.duration` is a non-nullable `String`**, where v10 typed it `String?`.

**`PushProvider` is an extension type over its wire string, and `Device.pushProvider` is a `PushProvider`.** The
four constants and their values are unchanged, and a `PushProvider` still compares equal to its string, so
`PushProvider.firebase` and `device.pushProvider == 'firebase'` keep working. A provider without a constant is
named by wrapping its value.

```dart
// v10
final String wireValue = PushProvider.firebase.name;
final device = Device(id: token, pushProvider: 'firebase');

// v11
final String wireValue = PushProvider.firebase;
final device = Device(id: token, pushProvider: PushProvider.firebase);
```

A `switch` over a `PushProvider` is no longer exhaustive; give it a default case.

### User Groups

**The eight user group methods return a `Result` instead of throwing.** `deleteUserGroup` carries no value on
success. `UserGroup`, `UserGroupMember` and the seven responses keep their names and fields.

```dart
// v10
try {
  final response = await client.searchUserGroups('eng');
  showGroups(response.userGroups);
} on StreamChatException catch (e) {
  report(e);
}

// v11
final result = await client.searchUserGroups('eng');
result.fold(
  onSuccess: (response) => showGroups(response.userGroups),
  onFailure: (error, _) => report(error),
);
```

**`userGroup` is nullable on the five single-group responses** — `GetUserGroupResponse`, `CreateUserGroupResponse`,
`UpdateUserGroupResponse`, `AddUserGroupMembersResponse` and `RemoveUserGroupMembersResponse`. The API does not
guarantee the group in the response, so handle `null`:

```dart
// v10
final group = (await client.getUserGroup(id)).userGroup;

// v11
final group = (await client.getUserGroup(id)).getOrNull()?.userGroup;
if (group == null) return;
```

**`UserGroup`, `UserGroupMember` and the responses no longer decode JSON.** They are plain classes; build them with
their constructors — `ListUserGroupsResponse(duration: '0ms', userGroups: [group])` where v10 wrote
`ListUserGroupsResponse()..userGroups = [group]`. `Message.mentionedGroups` still decodes from the same keys.
`UserGroup.fromData` and `toData` read and write the format the offline database stores; they are not a way to
decode API responses.

**The responses' `duration` is a non-nullable `String`**, where v10 typed it `String?`.

**`StreamChatApi.userGroups` is removed.** Call the user group methods on `StreamChatClient` instead.

### Link Previews

**`enrichUrl` returns a `Result` instead of throwing.** `OGAttachmentResponse` keeps its name and fields, and
`Attachment.fromOGAttachment` still takes it.

```dart
// v10
try {
  final og = await client.enrichUrl(url);
  showPreview(Attachment.fromOGAttachment(og));
} on StreamChatException catch (e) {
  report(e);
}

// v11
final result = await client.enrichUrl(url);
result.fold(
  onSuccess: (og) => showPreview(Attachment.fromOGAttachment(og)),
  onFailure: (error, _) => report(error),
);
```

**`OGAttachmentResponse` no longer decodes JSON.** It is a plain class; build it with its constructor —
`OGAttachmentResponse(duration: '0ms', ogScrapeUrl: url)` where v10 wrote `OGAttachmentResponse()..ogScrapeUrl = url`.

**`duration` is a non-nullable `String`**, where v10 typed it `String?`.

### Partial Updates

**Channel and member partial updates return a `Result` instead of throwing.** On the channel side that covers
`StreamChatClient.updateChannelPartial`, `enableSlowMode` and `disableSlowMode` (v10's `enableSlowdown` and
`disableSlowdown`), and `Channel.updatePartial`,
`updateName`, `updateImage`, `enableSlowMode` and `disableSlowMode`. On the member side it covers
`StreamChatClient.updateMemberPartial` (v10's `partialMemberUpdate`), `pinChannel`, `unpinChannel`,
`archiveChannel` and `unarchiveChannel`, and `Channel.pin`, `unpin`, `archive` and `unarchive`. The full update,
`updateChannel` and `Channel.update`, still throws. A `try`/`catch` around a partial update still compiles, but
no longer catches a failed call: read the returned `Result` instead.

```dart
// v10
try {
  final response = await channel.updatePartial(set: {'name': 'Support'});
  print(response.channel.name);
} on StreamChatException catch (e) {
  report(e);
}

// v11
final result = await channel.updatePartial(set: {'name': 'Support'});
result.fold(
  onSuccess: (response) => print(response.channel?.name),
  onFailure: (error, _) => report(error),
);
```

**The responses take the API's names.** `PartialUpdateChannelResponse` is now `UpdateChannelPartialResponse`, and
`PartialUpdateMemberResponse` is now `UpdateMemberPartialResponse`. Their fields keep their names.

**`StreamChatClient.enableSlowdown` and `disableSlowdown` are renamed `enableSlowMode` and `disableSlowMode`,** the
names `Channel` already used.

**`Channel.pin`, `unpin`, `archive` and `unarchive` answer the whole response**, where v10 returned the member:

```dart
// v10
final member = await channel.pin();

// v11
final result = await channel.pin();
final member = result.getOrThrow().channelMember;
```

**`UpdateChannelPartialResponse.channel` and `UpdateMemberPartialResponse.channelMember` are nullable**, where v10
typed them non-null. `UpdateChannelPartialResponse.members` goes the other way: it is a `List<Member>`, empty when
the channel has none, where v10 typed it `List<Member>?`.

**The responses no longer decode JSON.** They are plain classes; build them with their constructors —
`UpdateChannelPartialResponse(duration: '0ms', channel: channel)` where v10 wrote
`PartialUpdateChannelResponse()..channel = channel`. `duration` is a non-nullable `String`.

**`StreamChatApi.channel.updateChannelPartial`, `enableSlowdown`, `disableSlowdown` and `updateMemberPartial` are
removed.** Call them on `StreamChatClient`.

**`MemberUpdatePayload` and `MemberUpdateType` are removed.** They only named `pinned` and `archived`; pass the map
directly — `updateMemberPartial(channelId: …, channelType: …, set: {'pinned': true})` — or call `pinChannel`,
`archiveChannel` and their counterparts.

> **Why:** the endpoints moved onto the generated client, which returns a `Result` for every call; the field types
> follow what the API declares, and the names follow the API's so the channel and member updates share one scheme.
> `Channel.pin` and its siblings answer the whole response because every migrated write returns its envelope, so a
> field the API adds later reaches you without another break. `MemberUpdatePayload` and `MemberUpdateType` named
> only two of the keys a membership accepts, so a plain map replaces them.

### Channel Lifecycle

**Hiding, showing and deleting a channel return a `Result` instead of throwing.** That covers
`StreamChatClient.hideChannel`, `showChannel` and `deleteChannel`, `Channel.hide`, `show` and `delete`, and
`StreamChannelListController.deleteChannel` in `stream_chat_flutter_core`. A `try`/`catch` around one still
compiles, but no longer catches a failed call: read the returned `Result` instead.

```dart
// v10
try {
  await channel.delete();
  Navigator.of(context).pop();
} on StreamChatException catch (e) {
  report(e);
}

// v11
final result = await channel.delete();
result.fold(
  onSuccess: (_) => Navigator.of(context).pop(),
  onFailure: (error, _) => report(error),
);
```

**Each call answers its own response** where v10 answered `EmptyResponse`: `HideChannelResponse`,
`ShowChannelResponse` and `DeleteChannelResponse`, which carries the deleted channel in a nullable `channel`.

**`StreamChatApi.channel.hideChannel`, `showChannel` and `deleteChannel` are removed.** Call them on
`StreamChatClient`.

> **Why:** the endpoints moved onto the generated client, which returns a `Result` for every call. Each write
> answers its own envelope so a field the API adds later reaches you without another break.

### Moderation

**Muting, banning and flagging return a `Result` instead of throwing**, on both `StreamChatClient`
and `Channel`. `muteUser` and `unmuteUser` answer with the ids that matched no user, and the flag
methods with the review queue item the flag created; the rest carry no value. `OwnUser.mutes` follows
the `notification.mutes_updated` event and `OwnUser.channelMutes` the
`notification.channel_mutes_updated` event, as they always did.

```dart
// v10
try {
  await client.banUser(userId, {'timeout': 30, 'reason': 'spam'});
} on StreamChatException catch (e) {
  report(e);
}

// v11
final result = await client.moderation.banUser(
  userId,
  timeout: const Duration(minutes: 30),
  reason: 'spam',
);
result.fold(
  onSuccess: (_) => showBanned(),
  onFailure: (error, _) => report(error),
);
```

**`banUser`'s options map becomes named parameters**, mirroring the endpoint: `channelCid`,
`timeout`, `reason`, `shadow`, `ipBan` and `deleteMessages`. `timeout` is a `Duration` applied with
minute granularity, and never as less than one minute — a shorter one would mean no expiry at all.
On `Channel`, `banMember` and `shadowBan` take the same set
minus `channelCid`, which the channel supplies itself — so the `{'type': ..., 'id': ...}` pair those
methods used to send is gone, and with it a pair the API deprecated in favour of `channel_cid`.

**`unbanUser` takes only `channelCid`.** `remove_future_channels_ban` and `reason` were accepted by
the v1 endpoint and are not by its replacement. If you passed either through the options map, they no
longer reach the server.

**`removeShadowBan` is removed** from both `StreamChatClient.moderation` and `Channel`. It passed
`shadow: true` to unban, which no version of that endpoint has ever read, so it did exactly what
`unbanUser` and `Channel.unbanMember` do. Call those — they lift a shadow ban like any other.

**`unflagMessage` and `unflagUser` are removed**, rather than returning a `Result`. There is no v2
endpoint for them, and the v1 one stopped removing flags: it validated the request, answered
successfully, and left the flag in place. Both were deprecated here for that reason before v11. To
act on a flag, use the review queue through `DefaultApi.submitAction`.

**`flagMessage` and `flagUser` gain `reason` and `custom`,** which the endpoint stores alongside the
flag for whoever reviews it.

**These endpoints moved to the moderation v2 API.** `muteUser`, `unmuteUser`, `banUser`, `unbanUser`
and the flag methods now call `/api/v2/moderation/`, where our other SDKs already call them. Those
endpoints are in beta and are refused for an app explicitly pinned to the v1 moderation flow
(`moderation_enabled: false`) — contact support to enable moderation v2 if your app is one of them.
Muting and unmuting a *channel* are unaffected: they were already the endpoint the generated client
calls.

**The client's moderation methods moved to `client.moderation`.** They are now grouped on a
`ModerationClient`, reached through one field:

```dart
// v10
await client.muteUser(userId);

// v11
await client.moderation.muteUser(userId);
```

`Channel`'s moderation methods — `banMember`, `unbanMember`, `shadowBan`, `mute`, `unmute`
and `queryBannedUsers` — keep their place, because they are scoped to that channel.
`queryBannedUsers` stays on the client too.

**`queryBannedUsers` is unchanged and still throws**, on both the client and the channel. It is the
only moderation call that answers with a model, and the `User` and `ChannelModel` shapes it embeds
are decided by later groups in this migration; it moves when they do. See
[Endpoints that still throw](#endpoints-that-still-throw).

### App Settings

**`getAppSettings` returns a `Result` instead of throwing, and answers the whole response** rather than the
settings alone, so read them off `.app`. `AppSettings` and `UploadConfig` keep their fields and defaults, and
`client.appSettings` — the copy `connectUser` loads — is unchanged.

```dart
// v10
try {
  final settings = await client.getAppSettings();
  useSettings(settings);
} on StreamChatException catch (e) {
  report(e);
}

// v11
final result = await client.getAppSettings();
result.fold(
  onSuccess: (response) => useSettings(response.app),
  onFailure: (error, _) => report(error),
);
```

**`GetAppSettingsResponse` is renamed `AppSettingsResponse`,** with the same `duration` and `app` fields.

**`AppSettings`, `UploadConfig` and `AppSettingsResponse` no longer decode JSON.** All three are plain classes;
build them with their constructors — `AppSettingsResponse(duration: '0ms', app: settings)` where v10 wrote
`GetAppSettingsResponse()..app = settings`. `const AppSettings()`, `const UploadConfig()` and
`UploadConfig.defaultSizeLimit` are unchanged.

**`AppSettingsResponse.duration` is a non-nullable `String`**, where v10 typed it `String?`.

**`AppSettings` and `UploadConfig` no longer extend `Equatable`.** They still compare by value, `props` is
gone, and both gain `copyWith`.

### Guest Users

**`connectGuestUser` is unchanged.** It still returns the connected `OwnUser`, and still throws a
`StreamException` when the guest cannot be created or the connection fails.

**`StreamChatApi.guest` and `ConnectGuestUserResponse` are removed.** `connectGuestUser` creates the guest and
connects it in one call; there is no separate call that only creates one.

**The guest no longer stores your client state as custom data.** v10 sent the whole user, so fields such as
`online`, `banned`, the unread counts, devices and push preferences were saved on the new guest as custom data, and
some came back: an `OwnUser`'s `pushPreferences` on the returned user and in `extraData` when the guest was
queried, and the unread counts when connecting with `connectWebSocket: false`. None of them was ever applied to the
guest. v11 sends its id, name, image, language, `invisible`, an `OwnUser`'s privacy settings, and your own
`extraData`. If you read one of those values back, store it as a custom field of your own instead.

### File Upload

**Uploads and deletes return a `Result` instead of throwing.** `sendImage`, `sendFile`, `uploadImage` and
`uploadFile` answer an `UploadedFile`, and the deletes carry no value on success. That holds on `Channel` and on
`AttachmentFileUploader`. A canceled upload is a failure whose error is a `StreamNetworkException` with
`isCancelled` set.

```dart
// v10
try {
  final response = await channel.sendImage(file);
  setImage(response.file);
} on StreamChatException catch (e) {
  report(e);
}

// v11
final result = await channel.sendImage(file);
result.fold(
  onSuccess: (uploaded) => setImage(uploaded.fileUrl),
  onFailure: (error, _) => report(error),
);
```

**The response types are replaced by `UploadedFile`**, from `stream_core` and exported by this package.
`file` becomes `fileUrl`; `thumbUrl`, set for a video, is unchanged; `duration` is gone. Build one with
`UploadedFile(fileUrl: url)` where v10 wrote `SendFileResponse()..file = url`.

**A custom uploader returns a `Result`, and its provider receives a `Dio`.** Implement the same eight methods,
returning `Result`s, and build the uploader from the `Dio` the provider hands it — the client's own, with its
authentication and error handling.

```dart
// v10
StreamChatClient(apiKey, attachmentFileUploaderProvider: (httpClient) => MyUploader(httpClient));

// v11
StreamChatClient(apiKey, attachmentFileUploaderProvider: (dio) => MyUploader(dio));
```

---

## Migration Checklist

Work top to bottom; each item is independently verifiable.

- [ ] Update `stream_chat` (and any of `stream_chat_flutter`, `stream_chat_flutter_core`,
      `stream_chat_persistence`, `stream_chat_localizations` you depend on) to `^11.0.0`
- [ ] Wrap or fold every API call that previously used `try`/`catch` — see [Error Handling](#error-handling)
- [ ] Replace `on StreamChatNetworkError catch` with a `switch` over the sealed `StreamException` family — see
      [The error type changed too](#the-error-type-changed-too)
- [ ] Replace `ChatErrorCode` comparisons with `StreamErrorCode` constants
- [ ] Apply every row of the [Symbol Map](#symbol-map)
- [ ] Re-check custom data access: fields that used to arrive in `extraData` may now be typed properties
- [ ] If you implement `AttachmentFileUploader`, return a `Result` from it — see [File Upload](#file-upload)
- [ ] If you persist models yourself, re-check nullability as endpoints move to the generated types, which are nullable wherever the API allows it
- [ ] Replace `sort: null` on any list controller with `XSort.empty` if you relied on server ordering — see
      [Sorting](#sorting)
- [ ] If you use `stream_chat_persistence`, expect one cold start after upgrading — see [Offline Cache](#offline-cache)
- [ ] Run `dart analyze` and your test suite; the analyzer finds most of the mechanical work for you

---

## For AI Agents

If you are an agent performing this upgrade in a consumer codebase, work in this order:

1. **Bump the dependency** and run `dart pub get`, then `dart analyze`. The error list is your work queue — do not
   try to find call sites by reading code first.
2. **Apply the [Symbol Map](#symbol-map) top to bottom, reading the `Kind` column first.** `renamed` and `moved` rows are whole-symbol rewrites; prefer an
   identifier-aware rewrite over plain text replacement so you don't hit substrings or comments.
3. **Fix error handling per call site**, not globally. `getOrThrow()` preserves existing behaviour and is the
   correct minimal change when the caller already has a `try`/`catch`; use `fold` when the caller should handle
   both branches. Never swallow a `Failure` by defaulting to `null`.
4. **Re-run `dart analyze` after each group** and stop when it is clean. Then run the consumer's tests — type
   changes that compile can still change runtime behaviour, especially around nullability.
5. **Do not edit anything under `package:stream_chat/open_api/`.** It is generated and regenerated from the spec.
6. **Report what you could not resolve** rather than guessing: a removed symbol with no replacement in the Symbol
   Map means the capability moved or was dropped, and that needs a human decision.

---

## Contributing to this guide

If your PR lands a breaking change, add to this guide **in the same PR**. Three edits, in this order:

1. A row per changed symbol in the [Symbol Map](#symbol-map).
2. A row in [Quick Reference](#quick-reference) if the feature area is not listed yet.
3. A section under [Feature Areas](#feature-areas) using this template:

```markdown
### <Feature name>

#### Key Changes:

- <one bullet per user-visible change>

#### Migration Steps:

**Before:**
```dart
// v10 call site
```

**After:**
```dart
// v11 call site
```

> **Why:** <the reason the break was taken — long-term maintainability, or consistency with our other SDKs>
```

Keep the `Why` line. It is what tells a reader whether the change is worth arguing with, and it is the same
justification the PR needed in order to break API at all.
