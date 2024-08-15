import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/my_app.dart';

main() async {
  await GetStorage.init();
  runApp(const MyApp());
}
