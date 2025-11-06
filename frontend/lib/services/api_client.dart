import 'dart:convert';
import 'package:http/http.dart' as http;


/// TODO: adapter selon votre environnement (émulateur, device, web).
/// - Web local: http://localhost:8080
/// - Android émulateur: http://10.0.2.2:8080
/// - iOS simulateur: http://localhost:8080
// ignore: constant_identifier_names
const String BASE_URL = String.fromEnvironment('BACKEND_URL', defaultValue: 'http://localhost:8080');


class ApiClient {
final http.Client _client;
ApiClient({http.Client? client}) : _client = client ?? http.Client();


Future<String> hello() async {
final uri = Uri.parse('$BASE_URL/api/hello');
final res = await _client.get(uri, headers: {'Accept': 'text/plain, application/json'});
if (res.statusCode >= 200 && res.statusCode < 300) {
// si JSON {"message":"..."} on l’extrait, sinon texte brut
try {
final data = json.decode(res.body);
if (data is Map && data.containsKey('message')) return data['message'].toString();
} catch (_) {}
return res.body;
}
throw Exception('HTTP ${res.statusCode}: ${res.reasonPhrase}');
}
}