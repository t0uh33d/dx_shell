import 'package:dx_shell/dx_shell.dart';
import 'package:flutter/material.dart';

class WebInitializer extends StatefulWidget {
  const WebInitializer({super.key});

  @override
  State<WebInitializer> createState() => _WebInitializerState();
}

class _WebInitializerState extends State<WebInitializer> {
  @override
  void initState() {
    RouteHandler().redirect('/option-1', redirectionTime: 100);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}
