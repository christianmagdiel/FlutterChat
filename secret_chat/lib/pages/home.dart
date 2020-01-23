import 'package:flutter/material.dart';
import 'package:secret_chat/api/auth_api.dart';
import 'package:secret_chat/models/message.dart';
import 'package:secret_chat/providers/chat_provider.dart';
import 'package:secret_chat/providers/me.dart';
import 'package:secret_chat/utils/dialogs.dart';
import 'package:secret_chat/utils/session.dart';
import 'package:secret_chat/utils/socket_client.dart';
import 'package:secret_chat/widgets/chat.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _chatKey = GlobalKey<ChatState>();
  Me _me;
  ChatProvider _chat;
  final _authAPI = AuthApi();
  final _socketClient = SocketClient();

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  @override
  void dispose() {
    _socketClient.disconnect();
    super.dispose();
  }

  _connectSocket() async {
    final token = await _authAPI.getAccessToken();
    await _socketClient.connect(token);
    _socketClient.onNewMessage = (data) {
      print('home page new-message: ${data.toString()}');
      final message = Message(
          id: data['from']['id'],
          message: data['message'],
          username: data['from']['username'],
          createAt: DateTime.now());

      _chat.addMessage(message);
      _chatKey.currentState.checkUnread();
    };

    _socketClient.onConnected=(data){
      final users=  Map<String,dynamic>.from(data['connectedUsers']);
      print("connected: ${users.length}");
      _chat.counter=users.length;
    };

    _socketClient.onJoined=(data){
      _chat.counter++;
      print("Joined: ${data.toString()}");
    };

    _socketClient.onDisconnect=(data){
      if(_chat.counter>0){
      _chat.counter--;
      }
    };
  }

  _onExit() {
    Dialogs.confirm(context, title: "CONFIRM", message: "Are you sure?",
        onCancel: () {
      Navigator.pop(context);
    }, onConfirm: () async {
      Navigator.pop(context);
      Session session = Session();
      await session.clear();

      Navigator.pushNamedAndRemoveUntil(context, "login", (_) => false);
    });
  }

  _sendMessage(String text) {
    Message message = Message(
        id: _me.data.id,
        username: _me.data.username,
        message: text,
        type: 'text',
        createAt: DateTime.now());

        _socketClient.emit('send', text);
    _chat.addMessage(message);
    _chatKey.currentState?.goToEnd();
  }

  @override
  Widget build(BuildContext context) {
    _me = Me.of(context);
    _chat = ChatProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(child: Text("Connected (${_chat.counter})", style: TextStyle(color: Colors.black))),
        brightness: Brightness.light,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (String value) {
              if (value == "exit") {
                _onExit();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "share",
                child: Text('Share App'),
              ),
              PopupMenuItem(
                value: "exit",
                child: Text('Exit App'),
              )
            ],
          )
        ],
      ),
      body: SafeArea(
          child: Chat(_me.data.id,
              key: _chatKey,
              onSend: _sendMessage, 
              messages: _chat.messages)),
    );
  }
}
