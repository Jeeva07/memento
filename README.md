# memento (Task Management App)


This is a Flutter application for managing tasks with reminders, notifications, and theme adaptation. It includes platform-specific implementations for iOS and Android. Below, you'll find instructions for setting up and running the app, an overview of platform-specific implementations, and challenges faced during development.

---

## Features

- Create tasks with titles, descriptions, and reminder times.
- Set recurring tasks (daily, weekly, monthly).
- View and delete tasks from a task list.
- Notifications for reminders with task actions (mark as complete or snooze).
- Support for system-wide light/dark themes.
- Platform-specific implementations:
    - iOS: Haptic feedback and native notifications.
    - Android: Actionable notifications and persistence.

---

## Prerequisites

- Flutter SDK installed ([Installation Guide](https://docs.flutter.dev/get-started/install)).
- Dart configured in your development environment.
- A physical or virtual Android/iOS device.
- iOS setup (if applicable) requires a Mac with Xcode installed.

---

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/Jeeva07/memento.git
cd task-app
```

### 2. Install Dependencies

Run the following command to install the necessary packages:

```bash
flutter pub get
```

### 3. Run the Application

**For Android:**

```bash
flutter run -d android
```

**For iOS:**

```bash
flutter run -d ios
```

If using a simulator, ensure it is properly configured and running.

---

## Platform-Specific Implementations

### iOS

1. **Notifications**:
    - Utilized `flutter_local_notifications` to schedule reminders with task details.
    - Configured `DarwinNotificationDetails` for iOS-specific behavior.

2. **Haptic Feedback**:
    - Integrated haptic feedback (e.g., upon task creation and deletion) using `HapticFeedback.mediumImpact()`.

### Android

1. **Notifications**:
    - Used `AndroidNotificationDetails` to create actionable notifications with buttons for marking a task as done.
    - Ensured persistence of notifications across app restarts.

2. **Recurring Tasks**:
    - Added functionality to set daily, weekly, or monthly reminders.

---

## Challenges Faced

### 1. **Notification Permissions**
- **Issue**: Getting notifications to work seamlessly on both platforms required handling permissions.
- **Solution**: Ensured the `flutter_local_notifications` package requests necessary permissions during runtime.

### 2. **Timezone Issues**
- **Issue**: Scheduling notifications accurately across time zones.
- **Solution**: Integrated the `timezone` package to handle conversions and scheduling.

### 3. **Haptic Feedback**
- **Issue**: Some devices had inconsistent haptic feedback.
- **Solution**: Tested extensively on multiple devices to ensure reliable feedback.

---

## Dependencies

Here are the key dependencies used:

- `flutter_local_notifications`: For scheduling and managing notifications.
- `intl`: To format dates and times.
- `timezone`: For managing time zones.

Add the following dependencies to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_local_notifications: <latest version>
  intl: <latest version>
  timezone: <latest version>
```

---



## Future Enhancements

- Implement additional recurring options like custom intervals.
- Enhance UI/UX for better usability.
- Add local DB support and multi-language support.

---

## Contact

For issues or feature requests, please contact:
- **Name**: Jeeva S
- **Email**: jeevaabraham6@gmail.com

