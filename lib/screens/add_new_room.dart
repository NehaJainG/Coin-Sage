import 'package:flutter/material.dart';

import 'package:coin_sage/assets/icon.dart';
import 'package:coin_sage/assets/defaults.dart';
import 'package:coin_sage/data/room_list.dart';
import 'package:coin_sage/models/user.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _memberController = TextEditingController();
  List<User> members = [user1];
  String _enteredTitle = '';
  String _enteredMember = '';

  void memberSearch() {
    if (_memberController.text.isNotEmpty ||
        _memberController.text.length < 21) {
      print(_memberController.text);
      User? newMember = users.map(
        (user) {
          if (user.name == _memberController.text) {
            print(_memberController.text);

            return user;
          }
        },
      ).firstOrNull;
      if (newMember == null) {
        showSnackBar('No such user found. Try with other name.');
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
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: (context, constraints) {
        //backgroundColor: const Color.fromRGBO(255, 255, 255, 1),

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
                          // left: 0,
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
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: members.length == 1
                            ? const Text(
                                'No members added yet',
                              )
                            : Column(
                                children: [
                                  for (int index = 1;
                                      index < members.length;
                                      index++)
                                    Text(members[index].name)
                                ],
                              ),
                      ),
                      const SizedBox(height: 20),
                      FloatingActionButton.extended(
                        onPressed: () {},
                        label: const Text('Create Room'),
                        //icon: Icon(Icons.create_rounded),
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
