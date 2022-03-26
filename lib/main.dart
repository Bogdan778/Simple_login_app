import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_1/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(backgroundColor: Colors.grey),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return LoginScreen();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No user found for that email");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Login ',
            style: TextStyle(
                color: Colors.black, fontSize: 44, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 44.0,
          ),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(
                  Icons.mail,
                  color: Colors.black,
                )),
          ),
          const SizedBox(height: 26.0),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(
                  Icons.security,
                  color: Colors.black,
                )),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Don't remember your password?",
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
          const SizedBox(
            height: 88,
          ),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: const Color(0xFF0069FE),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () async {
                User? user = await loginUsingEmailPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                    BuildContext: BuildContext,
                    context: context);
                print(user);
                if (user != null) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          )
        ],
      ),
    );
  }
}
