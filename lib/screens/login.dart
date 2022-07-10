import 'package:sngpl/Animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:sngpl/screens/insert.dart';

const String username = "ahmed";
const String password = "123";

String pass;
String user;

class Login extends StatelessWidget {

  bool checker(String user, String pass){
    if(user == username && pass == password)
      return true;
    return false;
  }

  Widget check(String user,String pass){
    if(user!="" && pass!="") {
      if (user == username && pass == password) {
        return SizedBox(
          height: 2,
        );
      } else {
        return Container(
          padding: EdgeInsets.only(left: 50, top: 10),
          child: Text(
            'Incorrect credentials',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                height: 25,
                color: Colors.red
            ),
          ),
        );
      }
    }
    return SizedBox(
      height: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill
                      )
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeAnimation(1, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-1.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(1.3, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-2.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(1.5, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/clock.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        child: FadeAnimation(1.6, Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                          ),
                        )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(1.8, Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10)
                              )
                            ]
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[100]))
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Username",
                                    hintStyle: TextStyle(color: Colors.grey[400])
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                onChanged: (value){
                                  user=value.toString();
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey[400])
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                onChanged: (value){
                                  pass=value.toString();
                                },
                              ),
                            )
                          ],
                        ),
                      )),
                      SizedBox(height: 30,),
                      FadeAnimation(2, Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                  Color.fromRGBO(143, 148, 251, 1),
                                  Color.fromRGBO(143, 148, 251, .6),
                               ]
                            )
                        ),
                        child: Center(
                          child: FlatButton(
                              onPressed: (){
                                bool x;
                                x=checker(user, pass);
                                if(x==true){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => insert(),
                                    ),
                                  );
                                }
                                else
                                  print(0);
                              },
                              child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                        ),
                      )),
                      //check(user, pass),
                      //SizedBox(height: 70,),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}