import 'package:flutter/material.dart';


class ProfilePage extends StatelessWidget {
const ProfilePage({super.key});


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Profil')),
body: Center(
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Icon(Icons.account_circle, size: 96, color: Theme.of(context).colorScheme.primary),
const SizedBox(height: 12),
Text('Utilisateur démo', style: Theme.of(context).textTheme.titleMedium),
const SizedBox(height: 8),
Text('Bientôt: infos de compte, préférences, etc.',
style: Theme.of(context).textTheme.bodyMedium),
],
),
),
);
}
}