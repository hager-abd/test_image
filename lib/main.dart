import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'myapp.dart' show MyApp;
void main() async{
  final navigatorKey = GlobalKey<NavigatorState>();
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url:"https://xzmeomfszybrqkjfqngz.supabase.co",
    anonKey:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6bWVvbWZzenlicnFramZxbmd6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA5NjkzNjUsImV4cCI6MjA1NjU0NTM2NX0.RLbq8btKmZsTqvQwpiPXF76vB6QXnOh_2-n0dbLzCow" ,
  );
  runApp(const MyApp());
}
