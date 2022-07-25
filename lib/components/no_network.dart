import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flash_chat/components/errormessage.dart';

void noNetwork(BuildContext context) {
  Widget okButton = ElevatedButton(
  child: Text(
    "OK",
    style: TextStyle(
      fontSize: 15.0,
    ),
  ),
  onPressed: () {
    Navigator.of(context).pop();
  },
);
AlertDialog alert = AlertDialog(
  title: Text('It seems your internet is turned off'),
  content: Icon(
    Icons.wifi_off_rounded,
    size: 40.0,
  ),
  actions: [
    okButton,
  ],
);
showDialog(
  context: context,
  builder: (BuildContext context) {
    return alert;
  },
);
}

Future<int> checkConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return 1;
    }
  } on SocketException catch (_) {
    return 0;
  }
  return 0;
}


