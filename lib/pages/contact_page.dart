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
  Set<int> selectedContacts = {};
  bool selectionMode = false;

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

  /* void _deleteContact(int id) async {
    await ContactRepository.deleteContact(id);
    await loadContacts();
  }

  void _toggleSelection(Contact contact) {
    setState(() {
      selectionMode = true;
      selectedContacts.add(contact.id!);
    });
  } */

  void _exitSelectionMode() {
    setState(() {
      selectionMode = false;
      selectedContacts.clear();
    });
  }

  Future<void> _deleteSelected() async {
    for (final id in selectedContacts) {
      await ContactRepository.deleteContact(id);
    }
    _exitSelectionMode();
    await loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectionMode
              ? '${selectedContacts.length} seleccionados'
              : 'Contacts',
        ),
        actions: selectionMode
            ? [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _exitSelectionMode,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteSelected,
                ),
              ]
            : null,
      ),
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
            final isSelected = selectedContacts.contains(contact.id);

            return Row(
              children: [
                if (selectionMode)
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) {
                      setState(() {
                        if (isSelected) {
                          selectedContacts.remove(contact.id);
                          if (selectedContacts.isEmpty) {
                            selectionMode = false;
                          }
                        } else {
                          selectedContacts.add(contact.id!);
                        }
                      });
                    },
                  ),

                Expanded(
                  child: Card(
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
                      ),
                      title: Text(
                        contact.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(contact.email),

                      onLongPress: () {
                        setState(() {
                          selectionMode = true;
                          selectedContacts.add(contact.id!);
                        });
                      },

                      onTap: () {
                        if (selectionMode) {
                          setState(() {
                            if (isSelected) {
                              selectedContacts.remove(contact.id);
                              if (selectedContacts.isEmpty) {
                                selectionMode = false;
                              }
                            } else {
                              selectedContacts.add(contact.id!);
                            }
                          });
                        } else {
                          _showContactFormDialog(contact: contact);
                        }
                      },
                    ),
                  ),
                ),
              ],
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
