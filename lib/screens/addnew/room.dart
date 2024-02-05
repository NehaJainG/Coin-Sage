import 'package:coin_sage/services/room_repo.dart';
import 'package:coin_sage/services/user_repo.dart';
import 'package:flutter/material.dart';

import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/defaults/defaults.dart';

import 'package:coin_sage/models/user.dart';
import 'package:coin_sage/models/room.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  UserRepo userCollection = UserRepo();
  RoomRepositories roomRepo = RoomRepositories();
  final _memberController = TextEditingController();
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<User> members = [];
  String _errorMessage = '';
  bool validUser = true;

  Future<List<User>> get users async {
    final users = await userCollection.getAllUsers();
    return users;
  }

  void memberSearch() async {
    //validating if user with given email exists
    if (_memberController.text.isNotEmpty ||
        isValidEmail(_memberController.text)) {
      User? newMember = await userCollection.getUser(_memberController.text);

      //Does user's email given is valid?
      if (newMember == null) {
        validUser = false;
        _errorMessage = 'Enter a valid user email';
        print('invalid');
        _formKey.currentState!.validate();
        return;
      }

      //Check if user is already added
      if (members.where(
        (element) {
          return element.email == newMember.email;
        },
      ).isNotEmpty) {
        validUser = false;
        print('already');
        _errorMessage = 'User already added';
        _formKey.currentState!.validate();
        return;
      }

      //finally add user
      validUser = true;
      print('valid');
      _formKey.currentState!.validate();
      setState(() {
        members.add(newMember);
      });
    }
  }

  void createRoom() async {
    if (!isNotValidTitle(_titleController.text) && members.isNotEmpty) {
      print('here');
      //create data using room model
      Room room = Room(
        id: '',
        title: _titleController.text,
        members: members.map((e) => e.email).toList(),
      );
      //add data to firestore
      await roomRepo.addRoom(room);
      showSnackBar('Created the room', context);
      Navigator.of(context).pop();
      return;
    }
    showSnackBar('Failed to create the room', context);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 40, 20, keyboardSpace + 50),
              child: Form(
                key: _formKey,
                child: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(children: [
                        Text(
                          'Add New Room',
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: exitButton(context),
                        )
                      ]),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _titleController,
                        decoration: inputDecor(
                          'Title',
                          roomTitle,
                          null,
                          null,
                        ),
                        validator: (value) {
                          if (isNotValidTitle(_titleController.text)) {
                            print('text error');
                            return 'Must be between 1 and 20 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _memberController,
                              decoration: inputDecor(
                                'Member',
                                addMemberIcon,
                                null,
                                'Enter member\'s email',
                              ),
                              validator: (value) =>
                                  validUser ? null : _errorMessage,
                            ),
                          ),
                          //const SizedBox(width: 10),
                          IconButton(
                            onPressed: memberSearch,
                            icon: searchMemberIcon,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 200,
                        width: double.infinity,
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: members.length == 0
                            ? const Center(
                                child: Text(
                                  'No members added yet',
                                ),
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    for (int index = 0;
                                        index < members.length;
                                        index++)
                                      Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: lightGrey),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: ListTile(
                                          title: Text(members[index].name),
                                          trailing: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              setState(() {
                                                members.removeAt(index);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
                      FloatingActionButton.extended(
                        onPressed: createRoom,
                        label: const Text('Create Room'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
