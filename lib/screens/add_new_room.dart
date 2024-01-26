import 'package:flutter/material.dart';

import 'package:coin_sage/assets/icon.dart';
import 'package:coin_sage/assets/defaults.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  List<String>? members;
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
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: inputDecor(
                                'Member',
                                addMemberIcon,
                                null,
                                'Enter member\'s id',
                              ),
                            ),
                          ),
                          //const SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                              // Add your onPressed code here!
                            },
                            //label: const Text('Add a member'),
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
                        child: members == null
                            ? const Text(
                                'No members added yet',
                              )
                            : Column(
                                children: [
                                  for (String name in members!) Text(name)
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
