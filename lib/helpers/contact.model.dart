import 'package:lista_contatos/helpers/contact.field.table.dart';

class ContactModel {

  int id;
  String name;
  String email;
  String phone;
  String img;

  ContactModel();

  ContactModel.fromMap(Map contactMap) {
    id = contactMap[ContactFieldTable.id];
    name = contactMap[ContactFieldTable.name];
    email = contactMap[ContactFieldTable.email];
    phone = contactMap[ContactFieldTable.phone];
    img = contactMap[ContactFieldTable.img];
  }

  Map toMap() {
    Map<String, dynamic> contactMap = {
      ContactFieldTable.name: name,
      ContactFieldTable.email: email,
      ContactFieldTable.phone: phone,
      ContactFieldTable.img: img
    };
    if (id != null) {
      contactMap[ContactFieldTable.id] = id;
    }
    return contactMap;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }

}