import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBIKYGY-hq7Drin9gwAn5GvEIYLak48Grs",
        appId: "1:533926624337:android:584f6129ff9850d8c70c70",
        messagingSenderId: "",
        projectId: "clouddata-8e041",
        storageBucket: "clouddata-8e041.appspot.com"
    ));
  runApp(MaterialApp(home: register(),));
}


class register extends StatefulWidget{
  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  var name_controller = TextEditingController();
  var email_controller = TextEditingController();
  late CollectionReference _userCollection;

  @override
  void initState() {
    _userCollection=FirebaseFirestore.instance.collection('user');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Cloud Storage"),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: name_controller,
            decoration: const InputDecoration(
              labelText: "Name", border:  OutlineInputBorder()),
          ),
          TextField(
            controller: email_controller,
            decoration: const InputDecoration(
                labelText: "Email", border:  OutlineInputBorder()),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(onPressed: () {
            addUser();
          }, child: const Text("ADD USER")),
          StreamBuilder<QuerySnapshot>(
              stream: getUser(),
              builder: (context, snapshot){
                if (snapshot.hasError){
                  return Text("Error ${snapshot.error}");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final users =snapshot.data!.docs;
                return Expanded(
                    child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final userId = user.id;
                          final userName = user['name'];
                          final userEmail=user['email'];
                          return ListTile(
                            title: Text('$userName' , style: TextStyle(fontSize: 15),),
                            subtitle: Text('$userEmail', style: TextStyle(fontSize: 10),),
                            trailing: Wrap(
                              children: [
                                IconButton(onPressed: () {
                                  editUser(userId);
                                }, icon: Icon(Icons.edit)),
                                IconButton(onPressed: () {
                                  deleteUser(userId);
                                }, icon: Icon(Icons.delete)),

                              ],
                            ),
                          );
                        }));
              }),
        ],
        ),
      ),
    );
  }

  void editUser(var id) {
    showDialog(
        context: context,
        builder: (context) {
          final newname_cntlr = TextEditingController();
          final newemail_cntlr = TextEditingController();
          return AlertDialog(
            title: Text("Update User"),
            content: Column(mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: newname_cntlr,
                  decoration: InputDecoration(hintText: "Enter Name", border: OutlineInputBorder()),
                ),
                TextField(
                  controller: newemail_cntlr,
                  decoration: InputDecoration(hintText: "Enter Email", border: OutlineInputBorder()),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () {
                updateUser(id, newname_cntlr.text,newemail_cntlr.text).then((value){
                  Navigator.pop(context);
                });
              }, child: Text("update"))
            ],
          );
        });
  }

  ///create user
  Future<void>addUser()async{
    return _userCollection.add({
      'name':name_controller.text,
      'email':email_controller.text
    }).then((value) {
      print('User Added Succesfully');
      name_controller.clear();
      email_controller.clear();
    }).catchError((error){
      print('Failed To add User$error');
    });
  }
  ///read user
  Stream<QuerySnapshot> getUser(){
    return _userCollection.snapshots();
  }

  Future<void>updateUser(var id, String newname,String newemail) async {
    return _userCollection
        .doc(id)
        .update({"name": newname, "email": newemail}).then((value) {
       print("user Updated Successfully");
    }).catchError((error) {
     print("User data Updation failed$error");
    });
  }
  
  Future<void> deleteUser(var id) {
    return _userCollection.doc(id).delete().then((value) {
      print("User Deleted Successfully");
    }).catchError((error) {
      print("User deletion failed $error");
    });
  }

}

