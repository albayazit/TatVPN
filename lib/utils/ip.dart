import 'package:http/http.dart' as http;

// Получение публичного IP-адреса
Future<String> getPublicIP() async {
  try {
    var response = await http.get(Uri.parse('https://api.ipify.org'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Не удалось получить IP-адрес';
    }
  } catch (e) {
    return 'Ошибка: Нет соединения';
  }
}

// Получение статуса сервера
Future<String> getServerStatus() async {
  try {
    var response = await http.get(Uri.parse('http://109.120.133.241'));
    if (response.statusCode == 200) {
      return 'онлайн';
    } else {
      return 'оффлайн';
    }
  } catch (e) {
    return 'оффлайн';
  }
}