import 'package:first_app/models/contact.dart';
import 'package:first_app/repositories/contact_repository.dart';
import 'package:first_app/widgets/contact_form_widget.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact> contacts = [];

  Future<void> loadContacts() async {
    final contacts = await ContactRepository.getContacts();
    setState(() {
      this.contacts = contacts;
    });
  }

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  void _showContactFormDialog({Contact? contact}) async {
    final title = contact == null ? 'Add Contact' : 'Edit Contact';
    final result = await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: ContactFormWidget(contact: contact),
        );
      },
    );

    if (result != null) {
      await loadContacts();
    }
  }

  void _deleteContact(int id) async {
    await ContactRepository.deleteContact(id);
    await loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    contact.name[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ), // Avatar con primera inicial del nombre
                title: Text(
                  contact.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(contact.email),
                onTap: () => _showContactFormDialog(contact: contact),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _deleteContact(contact.id!),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showContactFormDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
