import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lista_contatos/helpers/contact.model.dart';

class ContactForm extends StatefulWidget {

  final ContactModel contact;

  ContactForm({this.contact});

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _contactEdited = false;
  
  ContactModel _editedContact;

  @override
  void initState() {
    super.initState();

    if(widget.contact == null) {
      _editedContact = ContactModel();
    } else {
      _editedContact = ContactModel.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;

    }

  }

  Widget _getFormLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: _editedContact.img != null ?
                    FileImage(File(_editedContact.img)) :
                      AssetImage("images/person.png")
                ),
              ),
            ),
            onTap: () {
              ImagePicker.pickImage(
                source: ImageSource.gallery,
              ).then((file) {
                if (file == null) return;
                setState(() {
                  _editedContact.img = file.path;                  
                });
              });
            },
          ),
          TextField(
            controller: _nameController,
            focusNode: _nameFocus,
            decoration: InputDecoration(labelText: "Nome"),
            onChanged: (text) {
              _contactEdited = true;
              setState(() {
                _editedContact.name = text;
              });
            },
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: "Email"),
            onChanged: (text) {
              _contactEdited = true;
              _editedContact.email = text;
            },
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: "Telefone"),
            onChanged: (text) {
              _contactEdited = true;
              _editedContact.phone = text;
            },
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_contactEdited) {
      showDialog(
        context:  context,
        builder: (context) {
          return AlertDialog(
            title: Text("Descartar alterações?"),
            content: Text("Se sair as alterações serão perdidas."),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sair"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: _getFormLayout(),
      ),
    );
  }
}