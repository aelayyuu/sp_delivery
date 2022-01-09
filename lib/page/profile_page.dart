import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String content;
  const ProfilePage({Key? key, required this.content}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.content),
      ),
    );
  }
}
