import 'package:flutter/material.dart';
import '../../services/api_client.dart';
import 'package:go_router/go_router.dart';


class DashboardPage extends StatefulWidget {
const DashboardPage({super.key});


@override
State<DashboardPage> createState() => _DashboardPageState();
}


class _DashboardPageState extends State<DashboardPage> {
final _api = ApiClient();
late Future<String> _helloFuture;


@override
void initState() {
super.initState();
_helloFuture = _api.hello();
}


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Dashboard'),
actions: [
IconButton(
onPressed: () => context.go('/profile'),
icon: const Icon(Icons.person_outline),
tooltip: 'Profil',
)
],
),
body: Center(
child: FutureBuilder<String>(
future: _helloFuture,
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
return const CircularProgressIndicator();
}
if (snapshot.hasError) {
return Text('Erreur: ${snapshot.error}');
}
return Column(
mainAxisSize: MainAxisSize.min,
children: [
const Text('Réponse backend /api/hello:'),
const SizedBox(height: 8),
Text(
snapshot.data ?? '(vide)',
style: Theme.of(context).textTheme.headlineMedium,
textAlign: TextAlign.center,
),
],
);
},
),
),
floatingActionButton: FloatingActionButton.extended(
onPressed: () => setState(() => _helloFuture = _api.hello()),
icon: const Icon(Icons.refresh),
label: const Text('Recharger'),
),
);
}
}