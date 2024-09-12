import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tatvpn/models/vpn.dart';
import 'package:tatvpn/screens/info.dart';
import 'package:tatvpn/utils/ip.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';   
import '../utils/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static String _ipAddress = 'Получение IP-адреса...';
  static String _ipAddressDevice = 'Получение IP-адреса...';
  static String _statusText = 'Вы не подключены';
  static String _trianText = 'ПОДКЛЮЧИТЬСЯ';
  static Image _mapImage = Image.asset('assets/images/map_off.png');
  static Image _trianImage = Image.asset('assets/images/trian_off.png', scale: 2,);
  static String _statusServer = 'оффлайн';
  static Color _iconColor = green;
  final VpnEngine vpn = VpnEngine();

  @override
  void initState() {
    super.initState();
    vpn.wireguard.vpnStageSnapshot.listen((event) {
      debugPrint("status changed $event");
      if (mounted) {
        switch (event) {
          case VpnStage.disconnected:
            setState(() {
              defaultState();
            });
          case VpnStage.connected:
            setState(() {
              connectedState();
            });
          case VpnStage.connecting:
            setState(() {
              connectionState();
            });
          default:
            setState(() {
              defaultState();
            });
        }
      }
    });
    _getIPAddress();
    _checkServer();
  }


  void connectionState() {
    _mapImage = Image.asset('assets/images/map_on.png');
    _trianImage = Image.asset('assets/images/trian_con.png');
    _trianText = "ПОДКЛЮЧЕНИЕ...";
    _ipAddress = _ipAddressDevice;
  }

  void connectedState() {
    _mapImage = Image.asset('assets/images/map_on.png');
    _trianImage = Image.asset('assets/images/trian_on.png', scale: 2,);
    _trianText = "ПОДКЛЮЧЕНО";
    _statusText = "Подключение защищено";
    _ipAddress = '109.120.133.241';
    _statusServer = 'онлайн';
    _iconColor = green;
  }
  void defaultState() {
    _mapImage = Image.asset('assets/images/map_off.png');
    _trianImage = Image.asset('assets/images/trian_off.png', scale: 2,);
    _trianText = "ПОДКЛЮЧИТЬСЯ";
    _statusText = "Вы не подключены";
    _ipAddress = _ipAddressDevice;
  }

  Future<void> _checkServer() async {
    String status = await getServerStatus();
    setState(() {
      _statusServer = status;
      if (_statusServer == 'оффлайн') {
        _iconColor = red;
      }
    });
  }
  
  Future<bool> _checkNet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  Future<void> _getIPAddress() async {
    String ipAddress = await getPublicIP();
    setState(() {
      _ipAddressDevice = ipAddress;
      _ipAddress = ipAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: const Icon(Icons.info_outlined, color: white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Info()));
                },
                ),
              ),
        ],
        centerTitle: true,
        title: const Text(
          "TatVPN",
          style: TextStyle(
            color: white,
            fontFamily: "Roboto",
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),),
        backgroundColor: Colors.transparent,
      ),
      body: homeOff(),
    );
  }

  Container connectStatus() {
  return Container(
    height: 70,
    margin: const EdgeInsets.only(top: 30),
    child: Column(
      children: [
        Text(_statusText,
          style: const TextStyle(
            color: white,
        ),),
        const SizedBox(height: 5,),
        Text("IP: $_ipAddress",
          style: const TextStyle(
            color: green,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
        ),)
      ]
      ),
    );
  }

  Container homeOff() {
    return Container(
      margin: const EdgeInsets.only(bottom: 80),
      child: Center(
        child:
        Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: GestureDetector (
                onTap:() async {
                  if (await vpn.wireguard.isConnected()) {
                    vpn.disconnect();
                    setState(() {
                      _getIPAddress();
                    });
                  } else {
                    _checkNet().then((value) {
                      if (value) {
                        vpn.initialize();
                      } else {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: altDark,
                          content: Text('Ошибка: Проверьте подключение к интернету',
                            style: TextStyle(
                              color: white
                            ),
                          ),
                        ));
                        setState(() {
                          _statusServer = 'оффлайн';
                          _iconColor = red;
                        });
                      }
                    });
                  }
                },
                child: mainTrian()),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                connectStatus(),
                serverStatus(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column mainTrian() {
  return Column (
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          _mapImage,
          _trianImage,
          Container( 
            margin: const EdgeInsets.only(top: 260),
            child: Text(
                    _trianText,
                    style: const TextStyle(
                      color: green,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ), 
      ],
    );
  }

  Container serverStatus() {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: ShapeDecoration(
          color: altDark,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
          ),
      ),
      child: Center(
        child: ListTile(
          leading: Image.asset("assets/images/flag.png", scale: 2,),
          title: const Text("Швеция", style: TextStyle(
          color: white,
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
          ),),
          trailing: SizedBox(
            width: 75,
            child: Center(
              child: Row(
              children: [
                Icon(Icons.brightness_1, size: 10, color: _iconColor),
                Container(
                  margin: const EdgeInsets.only(bottom: 2, left: 2),
                  child: Text(_statusServer, style: TextStyle(color: _iconColor, fontSize: 12.0, fontWeight: FontWeight.bold,),),),
              ],
            ),),
          ),
        ),
      ),
    );
  }
}
