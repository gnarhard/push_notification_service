import 'package:onesignal_flutter/onesignal_flutter.dart';

class PushNotificationService {
  final _oneSignal = OneSignal.shared;

  final String appId;
  final Set<String> notificationPrompt;
  bool allowNotifications = true;

  PushNotificationService({
    required this.appId,
    this.notificationPrompt = const {'prompt_notification', 'true'},
  });

  Future<void> init() async {
    //Remove this method to stop OneSignal Debugging
    await _oneSignal.setLogLevel(OSLogLevel.none, OSLogLevel.none);

    await _oneSignal.setAppId(appId);

    await askForPermission();
  }

  void setUserId(String userId) {
    _oneSignal.setExternalUserId(userId.toString());
  }

  void setUserEmail(String email) {
    _oneSignal.setEmail(email: email);
  }

  void setSMSNumber(String phoneNumber) {
    _oneSignal.setSMSNumber(smsNumber: phoneNumber);
  }

  void setLanguage(String language) {
    _oneSignal.setLanguage(language);
  }

  disable(bool disable) {
    _oneSignal.disablePush(disable);
  }

  Future<void> askForPermission() async {
    final shouldAskForPermission = await _shouldAskForPermission();
    if (shouldAskForPermission) {
      await _oneSignal.addTrigger(
          notificationPrompt.first, notificationPrompt.last);
    }
  }

  Future<bool> _shouldAskForPermission() async {
    OSDeviceState? state = await _oneSignal.getDeviceState();

    // Don't show if the user has disabled push notifications.
    if (state != null && state.pushDisabled && !allowNotifications) {
      return false;
    }

    // Don't show if the user has enabled push notifications.
    if (state != null && !state.pushDisabled && allowNotifications) {
      return false;
    }

    return true;
  }
}
