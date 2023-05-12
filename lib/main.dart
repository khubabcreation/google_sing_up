import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? photo_url, name;

  List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];
  GoogleSignIn? _googleSignIn;
  List<Widget> auth_control = [];
  Future<void> handleSignout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> handleSignIn() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    var userCredantials =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;
  }

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(
      // Optional clientId
      // clientId: 'your-client_id.apps.googleusercontent.com',
      scopes: scopes,
    );
  }

  @override
  Widget build(BuildContext context) {
    ///  here i am making a fuction when the user log in and log out
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          auth_control = [
            ElevatedButton(
                onPressed: () {
                  handleSignIn();
                },
                child: Text('Log in with google Khubaib'))
          ];
        });
      } else {
        name = user.displayName;
        photo_url = user.photoURL;
        setState(() {
          auth_control = [
            CircleAvatar(
              child: Image.network(photo_url!),
            ),
            Text(name!),
            ElevatedButton(
                onPressed: () {
                  handleSignout();
                },
                child: Text('Sign Me out'))
          ];
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Google SignUp'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: auth_control,
      ),
    );
  }
}
