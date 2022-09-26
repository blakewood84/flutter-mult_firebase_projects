import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mult_projects/firebase_options_aerotec.dart';
import 'package:mult_projects/firebase_options_dispatch.dart';

import 'dart:developer' as devtools;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptionsDispatch.currentPlatform);
  await Firebase.initializeApp(options: DefaultFirebaseOptionsAerotec.currentPlatform, name: 'aerotec');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  void _handleDispatch() async {
    final dispatch = Firebase.apps[1];
    final db = FirebaseFirestore.instanceFor(app: dispatch);

    final response = await db.collection('_companies').get();

    for(final item in response.docs) {
      devtools.log(item.data().toString());
    }

  }

  void _handleAerotec() async {
    final aerotec = Firebase.apps[0];
    final db = FirebaseFirestore.instanceFor(app: aerotec);

    final response = await db.collection('_companies').get();
    for(final item in response.docs) {
      devtools.log(item.data().toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _handleDispatch, child: const Text('Get Dispatch Info')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _handleAerotec, child: const Text('Get Aerotec Info')),
          ],
        ),
      ),
    );
  }
}