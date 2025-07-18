import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Getmycontactlist extends StatefulWidget {
  @override
  _GetmycontactlistState createState() => _GetmycontactlistState();
}

class _GetmycontactlistState extends State<Getmycontactlist> {
  TextEditingController _name = TextEditingController();
  TextEditingController _contact = TextEditingController();
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    getContactList();
  }

  Future<void> getContactList() async {
    bool permissionGranted = await FlutterContacts.requestPermission();
    if (!permissionGranted) return;

    List<Contact> fetchedContacts = await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: true,
    );

    setState(() {
      contacts = fetchedContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts')),
      body: contacts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return  Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // === Left: Avatar + Name + Phone (tappable InkWell) ===
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              await FlutterContacts.openExternalView(contact.id);
                            },
                            child: Row(
                              children: [
                                contact.photo != null
                                    ? CircleAvatar(backgroundImage: MemoryImage(contact.photo!))
                                    : CircleAvatar(child: Icon(Icons.person)),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        contact.displayName,
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        contact.phones.isNotEmpty
                                            ? contact.phones[0].number
                                            : 'No phone',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // === Right: Buttons ===
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.call, color: Colors.green),
                              onPressed: () async {
                                if (contact.phones.isNotEmpty) {
                                  await FlutterPhoneDirectCaller.callNumber(contact.phones[0].number);
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_forever, color: Colors.red),
                              onPressed: () async {
                                if (await FlutterContacts.requestPermission()) {
                                  await contact.delete();
                                  setState(() {
                                    contacts.removeAt(index);
                                  });
                                  Get.snackbar("Deleted", "${contact.displayName} was removed");
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );

                //   ListTile(
                //
                //   title: Text(contact.displayName),
                //   subtitle: Text(
                //     contact.phones.isNotEmpty
                //         ? contact.phones[0].number
                //         : 'No phone',
                //   ),
                //   leading: contact.photo != null
                //       ? CircleAvatar(
                //           backgroundImage: MemoryImage(contact.photo!),
                //         )
                //       : CircleAvatar(child: Icon(Icons.person)),
                //
                //   trailing: SizedBox(
                //     width: 80,
                //     child: Container(
                //       child: Padding(
                //         padding: EdgeInsets.only(
                //           right: 10
                //         ),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Expanded(
                //               child: IconButton(onPressed: () async{
                //                 await FlutterPhoneDirectCaller.callNumber(contact.phones[0].number);
                //               }, icon: Icon(Icons.call)),
                //             ),
                //             SizedBox(width: 30,),
                //             Expanded(
                //               child: Container(
                //                 width: 50,
                //                 child: IconButton(
                //                   onPressed: () async {
                //                     if (await FlutterContacts.requestPermission()) {
                //                       // await contacts[index].delete();
                //                       Get.snackbar("Are You Sure To Delete", "File Will be Deleted Forever");
                //                       setState(() {
                //                         contacts.removeAt(index);
                //                       });
                //                     }
                //                   },
                //                   icon: Icon(Icons.delete_forever),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     )
                //   ),
                // );
              },
            ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Get.bottomSheet(
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // this ensures it takes minimum space
                  children: <Widget>[
                    Text("Insert New Contact"),

                    TextField(
                      controller: _name,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Please enter your username',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: 20),
                    TextField(
                      controller: _contact,
                      decoration: InputDecoration(
                        labelText: 'Contact',
                        hintText: 'Please enter your Contact',
                        prefixIcon: Icon(Icons.contacts),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text("Close"),
                          onPressed: () => Get.back(),
                        ),

                        TextButton(
                          onPressed: () async {
                            if (await FlutterContacts.requestPermission()) {
                              if (_name.text.isEmpty || _contact.text.isEmpty) {
                                Get.snackbar(
                                  'Error',
                                  'Name and contact number are required',
                                );
                                return;
                              }
                              final newContact = Contact()
                                ..name = Name(first: _name.text)
                                ..phones = [Phone(_contact.text)];
                              await newContact.insert();
                              Get.snackbar('Success', 'Contact saved');
                              getContactList();
                              Get.back();
                            };
                          },
                          child: Text("Save"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },

        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}
