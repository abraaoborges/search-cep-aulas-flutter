import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:search_cep/views/home_page.dart';

void main() {
  runApp(DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => new ThemeData(
        primarySwatch: Colors.green,
        brightness: brightness,
      ),
      themedWidgetBuilder: (context, theme) {
        return new MaterialApp(
          title: 'Flutter Demo',
          theme: theme,
          home: new HomePage(),
        );
      }
    ));
}
