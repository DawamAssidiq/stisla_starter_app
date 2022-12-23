import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stisla_starter_app/base_url.dart';
import 'package:http/http.dart' as http;

class AuthLogin extends StatefulWidget {
  const AuthLogin({super.key});

  @override
  State<AuthLogin> createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  TextEditingController emailController = TextEditingController(text: 'superadmin@gmail.com');
  TextEditingController passwordController = TextEditingController(text: 'password');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 25, left: 25),
          child: Column(
            children: [
              const SizedBox(height: 80,),
              const Center(
                child: Text('Masuk', style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'San Serif',
                  fontWeight: FontWeight.bold
                ),),
              ),
      
              const SizedBox(height: 25,),
      
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Email : ')
              ),
      
              const SizedBox(height: 10,),
              
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    fontSize: 14
                  )
                ),
              ),
      
              const SizedBox(height: 20,),
      
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Password : ')
              ),
      
              const SizedBox(height: 10,),
      
              TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      fontSize: 14
                    )
                  ),
                ),
      
              const SizedBox(height: 20,),
      
              Container(
                height: 50,
                width: double.infinity,
                padding: const EdgeInsets.all(0),
                color: Colors.purple,
                child: TextButton(
                  onPressed: () async {
                    final headers = {
                      'Content-Type': 'application/json'
                    };

                    Map body = {
                      'email': emailController.text.trim(),
                      'password': passwordController.text,
                    };

                    final url = Uri.parse(UrlHelper().baseUrl + UrlHelper().login);

                    try{
                      final response = await http.post(url, body: jsonEncode(body), headers: headers);
                      print(response.statusCode);
                      print(response.body);

                      if(response.statusCode == 200){
                        final json = jsonDecode(response.body);
                        final preferences = await prefs;
                        preferences.setString('token', json['token']);

                        emailController.clear();
                        passwordController.clear();
                        print('Berhasil Login');
                        // ignore: use_build_context_synchronously
                      }else if(response.statusCode == 422){
                        throw jsonDecode(response.body)['data'] ?? 'Unknown Error Occured';
                      }else if(response.statusCode == 400){
                        throw jsonDecode(response.body)['errors'] ?? 'Unknown Error Occured';
                      }
                    }catch(error){
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            title: const Text('Info', style: TextStyle(
                              color: Colors.black,
                            ),),
                            contentPadding: const EdgeInsets.all(20),
                            children: [Text(error.toString())],
                          );
                        });
                    }
                  },
                  child: const Text('Masuk', style: TextStyle(
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.bold
                  ),),
                ),
              ),
      
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum punya akun? '),
                  InkWell(
                    onTap: () {
                      
                    },
                    child: const Text('Daftar', style: TextStyle(
                      color: Colors.green
                    ),)
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}