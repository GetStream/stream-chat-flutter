## 0.1.0

✅ Added

- Initial release of internal BDD-style test helpers for the `stream_chat` package: the `chatClientTest` and `channelTest` entry points, which build a real `StreamChatClient` with the REST API, WebSocket transport and persistence seams replaced.
- Added `isSameXxxAs` matchers for messages, drafts, attachments, users, events and channels.
- Added `createDefaultXxx` fixtures and response factories for users, channels, polls, drafts, reminders, members, reactions, replies, sync and unread counts, all with deterministic timestamps.
- Added `MockPersistenceClient` and `FakePersistenceClient` doubles for the persistence seam.
- Added `mockApi`, `mockApiFailure`, `mockApiFailureOnce`, `verifyApi`, `verifyApiCalled`, `verifyNeverCalled`, `verifyNoMoreApiInteractions` and `captureApi` for stubbing and verifying calls against the chat API's sub-APIs.
- Emitted events are serialized with server fidelity, so message and reaction payloads keep the server-assigned fields their own `toJson` drops (sender, timestamps, reactions, moderation).
