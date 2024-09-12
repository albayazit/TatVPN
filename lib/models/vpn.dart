import 'package:flutter/material.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';
import 'package:tatvpn/utils/config.dart';

class VpnEngine {
  final wireguard = WireGuardFlutter.instance;
  late String name = 'wg0';

  Future<void> initialize() async {
    try {
      await wireguard.initialize(interfaceName: name);
      debugPrint("initialize success $name");
      startVpn();
    } catch (error, stack) {
      debugPrint("failed to initialize: $error\n$stack");
    }
  }

  void startVpn() async {
    try {
      await wireguard.startVpn(
        serverAddress: '109.120.133.241:51820',
        wgQuickConfig: conf,
        providerBundleIdentifier: 'com.example.tatvpn',
      );
    } catch (error, stack) {
      debugPrint("failed to start $error\n$stack");
    }
  }

  void disconnect() async {
    try {
      await wireguard.stopVpn();
    } catch (e, str) {
      debugPrint('Failed to disconnect $e\n$str');
    }
  }

  Future<String> getStatus() async {
    debugPrint("getting stage");
    final stage = await wireguard.stage();
    debugPrint("stage: $stage");
    switch (stage) {
      case VpnStage.connected:
        return 'connected';
      case VpnStage.connecting:
        return 'connecting';
      case VpnStage.disconnected:
        return 'default';
      case VpnStage.noConnection:
        return 'default';
      default:
        return 'default';
    }
  }
}