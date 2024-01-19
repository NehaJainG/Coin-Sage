import 'package:flutter/material.dart';

import 'package:coin_sage/assets/icon.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  List<String>? members;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        appBar: AppBar(
          title: const Text('Add New Room'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Title',
                    prefixIcon: const Icon(Icons.groups_2_rounded),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: 'Member',
                          hintText: 'Enter member\'s id',
                          prefixIcon: addMemberIcon,
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
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: members == null
                      ? const Text(
                          'No members added yet',
                        )
                      : Column(
                          children: [for (String name in members!) Text(name)],
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
        ));
  }
}
