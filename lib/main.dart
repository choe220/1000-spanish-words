import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spanish_words/models/user.dart';
import 'firebase_options.dart';
import 'package:spanish_words/models/words.dart';
import 'package:spanish_words/views/menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    if (Platform.isAndroid) {
      SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
        ],
      );
    }
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 53, 53, 53),
        scaffoldBackgroundColor: const Color.fromARGB(255, 46, 46, 46),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<User?> getUser() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var user = await db.collection('users').doc('matt').get();

    if (user.data() != null) {
      return User.fromFirebase(user.data()!);
    } else {
      User user = await createUser();
      user.generateSet().then((value) async => await user.saveToFirebase());
      return user;
    }
  }

  Future<User> createUser() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var snapshot = await db.collection('words').get();
    List<Word> words =
        List<Word>.from(snapshot.docs.map((e) => Word.fromJson(e.data())));
    return User(words: words);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: FutureBuilder(
            future: getUser(),
            builder: (context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text(
                  snapshot.error.toString(),
                  style: const TextStyle(color: Colors.white),
                );
              }

              return ChangeNotifierProvider.value(
                value: snapshot.data,
                child: const Menu(),
              );
            },
          ),
        ),
      ),
    );
  }
}
