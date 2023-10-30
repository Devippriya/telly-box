import 'package:cable_record/Screens/home.dart';
import 'package:cable_record/Screens/loading.dart';
import 'package:cable_record/Screens/signin.dart';
import 'package:cable_record/Service/authentication.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //signin key
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String? error;

  Authentication auth = Authentication();

  String? validateEmail(String? value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_'{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern as String);
    if (!regex.hasMatch(value!) || value == null) {
      return "Enter an valid email address";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const SignIn()));
        },
        label: Text("Login"),
      ),
      body: Form(
        key: formKey1,
        child: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            const Text(
              "Sign up",
              style: TextStyle(
                color: Colors.red,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.1 * width, 25, 0.1 * width, 25),
                child: TextFormField(
                  validator: validateEmail,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      icon: Icon(
                        Icons.mail,
                      ),
                      focusedBorder: OutlineInputBorder()),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.1 * width, 25, 0.1 * width, 25),
                child: TextFormField(
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "enter valid password";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: "Password",
                      hintText: "Enter new password",
                      icon: Icon(
                        Icons.lock,
                      ),
                      focusedBorder: OutlineInputBorder()),
                  obscureText: true,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.1 * width, 25, 0.1 * width, 25),
                child: TextFormField(
                  validator: (val) {
                    if (val!.isEmpty || password != val) {
                      return "enter same password";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: "Confirm password",
                      hintText: "Enter password again",
                      icon: Icon(
                        Icons.lock,
                      ),
                      focusedBorder: OutlineInputBorder()),
                  obscureText: true,
                ),
              ),
            ),
            Text(error ?? ""),
            SizedBox(
              height: 50,
              width: 120,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () async {
                    if (formKey1.currentState!.validate()) {
                      error = await auth.SignupwithEmail(email, password);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Loading()));
                    }
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
