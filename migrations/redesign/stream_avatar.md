# Stream Avatar Components Migration Guide

This guide covers the migration for the redesigned avatar components in Stream Chat Flutter SDK.

---

## Table of Contents

- [Quick Reference](#quick-reference)
- [StreamUserAvatar](#streamuseravatar)
- [StreamChannelAvatar](#streamchannelavatar)
- [StreamGroupAvatar](#streamgroupavatar)
- [StreamUserAvatarStack](#streamuseravatarstack)
- [Size Reference](#size-reference)
- [Migration Checklist](#migration-checklist)

---

## Quick Reference

| Component | Key Changes |
|-----------|-------------|
| [**StreamUserAvatar**](#streamuseravatar) | `constraints` → `size` enum, `showOnlineStatus` → `showOnlineIndicator`, `onTap` removed |
| [**StreamChannelAvatar**](#streamchannelavatar) | `constraints` → `size` enum, `onTap` and builder callbacks removed |
| [**StreamGroupAvatar**](#streamgroupavatar) | Renamed to `StreamUserAvatarGroup`, `members` → `users` |
| [**StreamUserAvatarStack**](#streamuseravatarstack) | New component for overlapping avatars |

---

## StreamUserAvatar

### Breaking Changes:

- `constraints` parameter replaced with `size` enum (`StreamAvatarSize`)
- `showOnlineStatus` renamed to `showOnlineIndicator`
- `onTap` callback removed — wrap with `GestureDetector` or `InkWell` instead
- `borderRadius` parameter removed
- `selected`, `selectionColor`, `selectionThickness` parameters removed
- `onlineIndicatorAlignment` and `onlineIndicatorConstraints` removed

### Migration:

**Before:**
```dart
StreamUserAvatar(
  user: user,
  constraints: BoxConstraints.tight(const Size(40, 40)),
  borderRadius: BorderRadius.circular(20),
  showOnlineStatus: false,
  onTap: (user) => print('Tapped ${user.name}'),
)
```

**After:**
```dart
GestureDetector(
  onTap: () => print('Tapped ${user.name}'),
  child: StreamUserAvatar(
    size: StreamAvatarSize.lg,
    user: user,
    showOnlineIndicator: false,
  ),
)
```

> **Important:**
> - Use `GestureDetector` or `InkWell` to handle tap events
> - Use `StreamAvatarSize` enum values (`.xs`, `.sm`, `.md`, `.lg`, `.xl`) instead of `BoxConstraints`
> - See [Size Reference](#size-reference) for mapping old constraints to new enum values

---

## StreamChannelAvatar

### Breaking Changes:

- `constraints` parameter replaced with `size` enum (`StreamAvatarGroupSize`)
- `onTap` callback removed — wrap with `GestureDetector` or `InkWell` instead
- `borderRadius` parameter removed
- `selected`, `selectionColor`, `selectionThickness` parameters removed
- `ownSpaceAvatarBuilder`, `oneToOneAvatarBuilder`, `groupAvatarBuilder` callbacks removed

### Migration:

**Before:**
```dart
StreamChannelAvatar(
  channel: channel,
  constraints: BoxConstraints.tight(const Size(40, 40)),
  onTap: () => print('Tapped channel'),
  selected: isSelected,
)
```

**After:**
```dart
GestureDetector(
  onTap: () => print('Tapped channel'),
  child: StreamChannelAvatar(
    size: StreamAvatarGroupSize.lg,
    channel: channel,
  ),
)
```

> **Important:**
> - Use `StreamAvatarGroupSize` enum values (`.lg`, `.xl`) instead of `BoxConstraints`
> - Custom avatar builders are no longer supported

---

## StreamGroupAvatar

### Breaking Changes:

- Renamed from `StreamGroupAvatar` to `StreamUserAvatarGroup`
- `members` parameter replaced with `users` (`Iterable<User>` instead of `List<Member>`)
- `constraints` parameter replaced with `size` enum (`StreamAvatarGroupSize`)
- `channel` parameter removed
- `onTap` callback removed — wrap with `GestureDetector` or `InkWell` instead
- `borderRadius` parameter removed
- `selected`, `selectionColor`, `selectionThickness` parameters removed

### Migration:

**Before:**
```dart
StreamGroupAvatar(
  channel: channel,
  members: otherMembers,
  constraints: BoxConstraints.tight(const Size(40, 40)),
  onTap: () => print('Tapped group'),
)
```

**After:**
```dart
GestureDetector(
  onTap: () => print('Tapped group'),
  child: StreamUserAvatarGroup(
    size: StreamAvatarGroupSize.lg,
    users: otherMembers.map((m) => m.user!),
  ),
)
```

> **Important:**
> - Extract `User` objects from `Member` when migrating: `members.map((m) => m.user!)`
> - The component no longer requires a `channel` reference

---

## StreamUserAvatarStack

### Breaking Changes:

- **New component** for displaying overlapping user avatars (e.g., thread participants)
- Replaces custom `Stack` + `Positioned` implementations

### Parameters:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `users` | `Iterable<User>` | required | Users to display |
| `size` | `StreamAvatarStackSize?` | `.sm` | Size of avatars |
| `max` | `int` | `5` | Max avatars before overflow badge |
| `overlap` | `double` | `0.33` | Overlap fraction (0.0 - 1.0) |

### Usage:

```dart
StreamUserAvatarStack(
  max: 3,
  size: StreamAvatarStackSize.xs,
  users: threadParticipants,
)
```

> **Important:**
> - Use this component instead of manually building overlapping avatar stacks
> - The `overlap` parameter controls how much each avatar overlaps the previous one

---

## Size Reference

### StreamAvatarSize

| Old Constraints | New Size | Diameter |
|-----------------|----------|----------|
| `BoxConstraints.tight(Size(20, 20))` | `.xs` | 20px |
| `BoxConstraints.tight(Size(24, 24))` | `.sm` | 24px |
| `BoxConstraints.tight(Size(32, 32))` | `.md` | 32px |
| `BoxConstraints.tight(Size(40, 40))` | `.lg` | 40px |
| `BoxConstraints.tight(Size(64, 64))` | `.xl` | 64px |

### StreamAvatarGroupSize

| Old Constraints | New Size | Diameter |
|-----------------|----------|----------|
| `BoxConstraints.tight(Size(40, 40))` | `.lg` | 40px |
| `BoxConstraints.tight(Size(64, 64))` | `.xl` | 64px |

### StreamAvatarStackSize

| Old Constraints | New Size | Diameter |
|-----------------|----------|----------|
| `BoxConstraints.tight(Size(20, 20))` | `.xs` | 20px |
| `BoxConstraints.tight(Size(24, 24))` | `.sm` | 24px |

> **Note:**
> If your old constraints don't match exactly, choose the closest available size.

---

## Migration Checklist

- [ ] Replace `StreamUserAvatar` `constraints` with `size` enum (`StreamAvatarSize`)
- [ ] Rename `showOnlineStatus` to `showOnlineIndicator`
- [ ] Move `onTap` callbacks to parent `GestureDetector` or `InkWell` widgets
- [ ] Replace `StreamGroupAvatar` with `StreamUserAvatarGroup`
- [ ] Change `members` parameter to `users` (extract `User` from `Member`)
- [ ] Replace `StreamChannelAvatar` `constraints` with `size` enum (`StreamAvatarGroupSize`)
- [ ] Remove `selected`, `selectionColor`, `selectionThickness` parameters
- [ ] Use `StreamUserAvatarStack` for overlapping avatar displays
