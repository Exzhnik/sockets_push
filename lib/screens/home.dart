import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:math';

import '../message.dart';

class HomePage extends StatefulWidget {
  final WebSocketChannel channel;
  HomePage({Key key, this.title, @required this.channel}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();
  List<Message> messages = List<Message>();
  final rand = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                return Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10.0);
                    },
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Text(
                              snapshot.hasData
                                  ? '${messages[index].description}'
                                  : '',
                              style: TextStyle(color: Colors.white, fontSize: 18.0,),
                            
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),

            SizedBox(height: 10,),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Send any message",
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    controller: _controller,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                  onPressed: _sendMyMessage,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendMyMessage() {
    if (_controller.text.isNotEmpty) {
      widget.channel.sink.add(_controller.text);
    }
    setState(() {
      messages.insert(0, Message(rand.nextInt(2), _controller.text));
    });

    _controller.clear();
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
