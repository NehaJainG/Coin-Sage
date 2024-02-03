import 'package:coin_sage/defaults/colors.dart';
import 'package:flutter/material.dart';

import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/data/room_list.dart';
import 'package:coin_sage/models/user.dart';
import 'package:coin_sage/models/room.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _memberController = TextEditingController();
  List<User> members = [user1];
  String _enteredTitle = '';

  void memberSearch() {
    if (_memberController.text.isNotEmpty ||
        _memberController.text.length < 21) {
      print(_memberController.text);
      User? newMember = users.where(
        (user) {
          return user.name == _memberController.text;
        },
      ).firstOrNull;
      if (newMember == null) {
        showSnackBar('No such user found. Try with other name.');
        return;
      }
      if (members.contains(newMember)) {
        showSnackBar('User already added.');
        return;
      }
      setState(() {
        members.add(newMember);
      });
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(
          message,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void createRoom() {
    Room r1 = Room(
      id: 'sample',
      title: _enteredTitle,
      members: members,
    );
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
              padding: EdgeInsets.fromLTRB(20.0, 40, 20, keyboardSpace + 20),
              child: Form(
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
                      const SizedBox(height: 10),
                      TextFormField(
                          decoration: inputDecor(
                            'Title',
                            roomTitle,
                            null,
                            null,
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 20) {
                              return 'Must be between 1 and 20 characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredTitle = value!;
                          }),
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
                                'Enter member\'s name',
                              ),
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
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: members.length == 1
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
                                    for (int index = 1;
                                        index < members.length;
                                        index++)
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: lightGrey),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: ListTile(
                                          title: Text(members[index].name),
                                          trailing: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {},
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
