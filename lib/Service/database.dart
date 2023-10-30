import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cable_record/model/customer.dart';

class Database {
  final String? uid;
  Database({this.uid});

  Future<void> deleteDate(String id, String paydate) {
    return FirebaseFirestore.instance
        .collection('Users/$uid/Customers')
        .doc(id)
        .update({
          'Paydate.$paydate': FieldValue.delete(),
        })
        .then((value) => print("date deleted"))
        .catchError((error) => print("Failed to update connection: $error"));
  }

  Future<void> updateConnection(bool con, String id) {
    return FirebaseFirestore.instance
        .collection('Users/$uid/Customers')
        .doc(id)
        .update({
          'Connection': con,
        })
        .then((value) => print("Connection updated"))
        .catchError((error) => print("Failed to update connection: $error"));
  }

  Future<void> updatePayment(
      bool pay, String id, String paydate, String amount) {
    if (pay == true) {
      return FirebaseFirestore.instance
          .collection('Users/$uid/Customers')
          .doc(id)
          .update({
            'Payment': pay,
            'Paydate.$paydate': amount,
          })
          .then((value) => print("Connection updated"))
          .catchError((error) => print("Failed to update connection: $error"));
    } else {
      return FirebaseFirestore.instance
          .collection('Users/$uid/Customers')
          .doc(id)
          .update({
            'Payment': pay,
          })
          .then((value) => print("Connection updated"))
          .catchError((error) => print("Failed to update connection: $error"));
    }
  }

  Future<void> clearPayment() {
    return FirebaseFirestore.instance
        .collection('Customers')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.update({
          'Payment': false, //True or false
        });
      }
    });
  }

  Future<void> createCustomer(Customer customer) {
    return FirebaseFirestore.instance
        .collection('Users/$uid/Customers')
        .add({
          'Name': customer.name,
          'Connection': customer.isconnected,
          'Payment': customer.ispaid,
          'BoxNumber': customer.boxnumber,
          'PhoneNumber': customer.phonenumber,
          'Address': customer.address,
          'Package': customer.package,
          'ConnectAt': customer.date,
          'Paydate': customer.paydate,
          'Pending': false,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updatePending(String id, bool pending) {
    return FirebaseFirestore.instance
        .collection('Users/$uid/Customers')
        .doc(id)
        .update({
          'Pending': pending,
        })
        .then((value) => print("User updated"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateCustomer(Customer customer, String id) {
    return FirebaseFirestore.instance
        .collection('Users/$uid/Customers')
        .doc(id)
        .update({
          'Name': customer.name,
          'Connection': customer.isconnected,
          'Payment': customer.ispaid,
          'BoxNumber': customer.boxnumber,
          'PhoneNumber': customer.phonenumber,
          'Address': customer.address,
          'Package': customer.package,
          'ConnectAt': customer.date,
        })
        .then((value) => print("User updated"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
