
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
  show debugDefaultTargetPlatformOverride;
import 'package:lista_contatos/pages/home.page.dart';

void main() {
  if (!Platform.isAndroid && !Platform.isIOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Lista de Contatos",
    home: HomePage(),
  ));
}