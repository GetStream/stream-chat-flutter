# 0.1.0

- Initial release of internal BDD-style test helpers for the `stream_chat` package.
- Added `isSameXxxAs` matchers for messages, drafts, attachments, users, events and channels.
- Added `createDefaultChannelConfig`, `createDefaultErrorResponse` and `createDefaultNetworkError` fixtures.
- Added `MockPersistenceClient` and `FakePersistenceClient` doubles for the persistence seam.
- Emitted events are now serialized with server fidelity, so message and reaction payloads keep their server-assigned fields (sender, timestamps, reactions).
- Added `createDefaultXxx` fixtures and response factories for users, polls, drafts, reminders, members, reactions, replies, sync and unread counts.
- Added `mockApiFailureOnce`, `verifyNoMoreApiInteractions` and a `delay` option on the API mockers.
