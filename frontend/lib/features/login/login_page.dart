import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class LoginPage extends StatefulWidget {
const LoginPage({super.key});


@override
State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
final _formKey = GlobalKey<FormState>();
final _emailCtrl = TextEditingController();
final _pwdCtrl = TextEditingController();


@override
void dispose() {
_emailCtrl.dispose();
_pwdCtrl.dispose();
super.dispose();
}


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Se connecter')),
body: Center(
child: ConstrainedBox(
constraints: const BoxConstraints(maxWidth: 420),
child: Card(
margin: const EdgeInsets.all(16),
child: Padding(
padding: const EdgeInsets.all(16),
child: Form(
key: _formKey,
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
TextFormField(
controller: _emailCtrl,
decoration: const InputDecoration(labelText: 'Email'),
validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
),
const SizedBox(height: 12),
TextFormField(
controller: _pwdCtrl,
decoration: const InputDecoration(labelText: 'Mot de passe'),
obscureText: true,
validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
),
const SizedBox(height: 16),
SizedBox(
width: double.infinity,
child: FilledButton(
onPressed: () {
if (_formKey.currentState!.validate()) {
// Pour l’instant, on redirige sans auth réelle
context.go('/dashboard');
}
},
child: const Text('Continuer'),
),
),
],
),
),
),
),
),
),
);
}
}