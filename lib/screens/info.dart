import 'package:flutter/material.dart';
import '../utils/colors.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
          )
        ],
        title: const Text(
          "Информация", 
          style: TextStyle(
            color: white,
            fontFamily: "Roboto",
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),),
        backgroundColor: Colors.transparent,
      ),
      body: infoText(),
    );
  }  
}

Container infoText() {
  return Container(
    margin: const EdgeInsets.all(20),
    child: const Text(
      "VPN-клиент работающий на основе протокола WireGuard.\nМаксимальная пропускная способность сервера - 100 Мбит/с.\nИспользуемый протокол передачи данных - UDP.\n\n Telegram - @bayazitkhasan",
      style: TextStyle(
        color: white,
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}