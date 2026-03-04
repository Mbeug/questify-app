// lib/features/dashboard/hello_card.dart
import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class HelloCard extends StatefulWidget {
  const HelloCard({super.key, this.api});
  final ApiService? api;

  @override
  State<HelloCard> createState() => _HelloCardState();
}

class _HelloCardState extends State<HelloCard> {
  late final ApiService _api;
  Future<String>? _helloFuture;
  bool _snackbarShown = false;

  @override
  void initState() {
    super.initState();
    _api = widget.api ?? ApiService();
    _helloFuture = _api.getHello();
  }

  void _retry() {
    setState(() {
      _snackbarShown = false;
      _helloFuture = _api.getHello();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<String>(
          future: _helloFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Row(
                children: [
                  SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                  SizedBox(width: 12),
                  Text('Connexion au serveur...'),
                ],
              );
            }

            if (snapshot.hasError) {
              if (!_snackbarShown) {
                _snackbarShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  final msg = snapshot.error.toString();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(msg),
                        behavior: SnackBarBehavior.floating),
                  );
                });
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(child: Text('Erreur lors de l\'appel API')),
                  TextButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reessayer')),
                ],
              );
            }

            final text = snapshot.data ?? '--';
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(text,
                        style: Theme.of(context).textTheme.titleMedium)),
                IconButton(onPressed: _retry, icon: const Icon(Icons.refresh)),
              ],
            );
          },
        ),
      ),
    );
  }
}
