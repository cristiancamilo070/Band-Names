
import 'package:band_names/providers/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final  socketService = Provider.of<SocketService>(context);
    
    return Scaffold(
      body: Center(child: Text('xdddddddd'),),
    );
  }
}