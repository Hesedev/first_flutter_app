import 'package:first_app/models/contact.dart';
import 'package:first_app/repositories/contact_repository.dart';
import 'package:flutter/material.dart';

class ContactFormWidget extends StatefulWidget {
  final Contact? contact;
  const ContactFormWidget({super.key, this.contact});

  @override
  State<ContactFormWidget> createState() => _ContactFormWidgetState();
}

class _ContactFormWidgetState extends State<ContactFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String name = '', email = '', phone = '', address = '';

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      name = widget.contact?.name ?? '';
      email = widget.contact?.email ?? '';
      phone = widget.contact?.phone ?? '';
      address = widget.contact?.address ?? '';
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      // Cuando esto se llama los metodos onSaved de cada TextFormField se ejecutan y guardan los valores en las variables
      _formKey.currentState!.save();

      final contact = Contact(
        id: widget.contact?.id,
        name: name,
        email: email,
        phone: phone,
        address: address,
      );

      if (widget.contact != null) {
        await ContactRepository.updateContact(contact);
      } else {
        await ContactRepository.addContact(contact);
      }
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              initialValue: name,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              onSaved: (v) => name = v ?? '',
            ),
            TextFormField(
              initialValue: email,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              onSaved: (v) => email = v ?? '',
            ),
            TextFormField(
              initialValue: phone,
              decoration: const InputDecoration(labelText: 'Phone'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              onSaved: (v) => phone = v ?? '',
            ),
            TextFormField(
              initialValue: address,
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              onSaved: (v) => address = v ?? '',
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  /* onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.of(context).pop(Contact(
                        name: name,
                        email: email,
                        phone: phone,
                        address: address,
                      ));
                    }
                  }, */
                  onPressed: _save,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
