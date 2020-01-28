import 'package:flutter/material.dart';
import 'package:sockets_push/screens/home.dart';
import 'package:web_socket_channel/io.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message',
      
      home: HomePage(title: 'Message', channel: IOWebSocketChannel.connect('ws://echo.websocket.org'),),
      theme: ThemeData(
        primaryColor: Colors.teal,
        accentColor: Colors.green
      ),
      
    );
  }
}

