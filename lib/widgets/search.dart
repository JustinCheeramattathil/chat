import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/select_contacts/controller/select_contacts_controller.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Contact> filteredContactList = [];

  // void filterContacts(String query) {
  //   final contactList = ref.read(getContactsProvider);
  //   setState(() {
  //     if (query.isEmpty) {
  //       filteredContactList = contactList.value!;
  //     } else {
  //       filteredContactList = contactList.value!
  //           .where((contact) =>
  //               contact.displayName.toLowerCase().contains(query.toLowerCase()))
  //           .toList();
  //     }
  //   });
  // }

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search Page'),
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (query) {
                  // filterContacts(query);
                },
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Search ..',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: filteredContactList.length,
                  itemBuilder: ((context, index) {
                    return InkWell(
                      onTap: () => selectContact(
                          ref, filteredContactList[index], context),
                      child: ListTile(
                        leading: Text(filteredContactList[index].displayName),
                      ),
                    );
                  })),
            ),
          ],
        ));
  }
}
