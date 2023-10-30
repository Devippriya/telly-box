import 'package:cable_record/Screens/loading.dart';
import 'package:cable_record/Service/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cable_record/Service/database.dart';
import 'package:cable_record/model/customer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var value = "-1";

  bool isConnected = false;
  bool isPaid = false;
  Customer customer = Customer();

  final GlobalKey<FormState> homeKey = GlobalKey<FormState>();

  final GlobalKey<FormState> customerKey = GlobalKey<FormState>();

  var user = FirebaseAuth.instance.currentUser;

  late Stream<QuerySnapshot> customersStream = FirebaseFirestore.instance
      .collection('Users/${user!.uid}/Customers')
      .snapshots();

  DateTime selectedDate = DateTime.now();

  TextEditingController _datecontrol = TextEditingController();

  TextEditingController _dateupdate = TextEditingController();

  TextEditingController _paydate = TextEditingController();

  String amount = " ";

  bool pending = false;

  String payAmount = " ";

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      setState(() {
        _datecontrol.text = _picked.toString().split(" ")[0];
        customer.date = _picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> _updateDate(String date) async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      setState(() {
        _dateupdate.text = _picked.toString().split(" ")[0];
        custUpdate.date = _picked.toString().split(" ")[0];
      });
    } else {
      custUpdate.date = date;
    }
  }

  String paydate = "";

  Authentication auth = Authentication();

  Future<void> _payDate(String date) async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      setState(() {
        _paydate.text = _picked.toString().split(" ")[0];
        paydate = _picked.toString().split(" ")[0];
      });
    } else {
      paydate = date;
    }
  }

  Customer custUpdate = Customer();

  String name = '';

  void updateBox(Customer cust, String id) {
    _dateupdate.text = cust.date!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Update Customer Details"),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: 600,
            child: Form(
              key: customerKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 20, 20),
                          child: TextFormField(
                            initialValue: cust.name,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Enter name";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                custUpdate.name = val;
                              });
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                label: Text("Name"),
                                hintText: "Enter customer name",
                                icon: Icon(Icons.person)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 20, 20),
                          child: TextFormField(
                            initialValue: cust.boxnumber,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "enter box number";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                custUpdate.boxnumber = val;
                              });
                            },
                            decoration: const InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(),
                              label: Text("Box Number"),
                              hintText: "Enter box Number",
                              icon: Icon(Icons.dvr),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 20, 20),
                          child: TextFormField(
                            initialValue: cust.phonenumber,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Enter Phone number";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                custUpdate.phonenumber = val;
                              });
                            },
                            decoration: const InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(),
                              label: Text("Phone number"),
                              hintText: "Enter phone number",
                              icon: Icon(Icons.phone),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 20, 20),
                          child: TextFormField(
                            initialValue: cust.package,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "enter package amount";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                custUpdate.package = val;
                              });
                            },
                            decoration: const InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(),
                              label: Text("Package amount"),
                              hintText: "Enter package amount",
                              icon: Icon(Icons.currency_rupee),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 20, 20),
                    child: TextFormField(
                      initialValue: cust.address,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "enter address";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (val) {
                        setState(() {
                          custUpdate.address = val;
                        });
                      },
                      decoration: const InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(),
                        label: Text("Address"),
                        hintText: "Enter Address",
                        icon: Icon(Icons.location_city),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Text("Connection Status : "),
                      Switch(
                        onChanged: (val) {
                          setState(() {
                            custUpdate.isconnected = val;
                          });
                        },
                        value: cust.isconnected,
                        activeColor: Colors.green,
                        activeTrackColor: Colors.greenAccent,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 20, 20),
                          child: TextFormField(
                            controller: _dateupdate,
                            decoration: const InputDecoration(
                              //labelText: cust.date,
                              border: OutlineInputBorder(),
                              filled: true,
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                            onTap: () {
                              _updateDate(cust.date!);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Payment Status : "),
                      if (cust.pending == true)
                        const Text(
                          "Pending",
                          style: TextStyle(
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        )
                      else if (cust.ispaid == true)
                        const Text(
                          "Paid",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        )
                      else
                        const Text("Not paid",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      title: const Text("Add Payment details"),
                                      content: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 10, 20, 20),
                                              child: TextFormField(
                                                // initialValue: cust.phonenumber,

                                                validator: (val) {
                                                  if (val!.isEmpty) {
                                                    return "Enter amount";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                onChanged: (val) {
                                                  setState(() {
                                                    payAmount = val;
                                                  });
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                  filled: true,
                                                  border: OutlineInputBorder(),
                                                  label: Text("Payment amount"),
                                                  hintText:
                                                      "Enter payment amount",
                                                  icon: Icon(
                                                      Icons.currency_rupee),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 10, 20, 20),
                                              child: TextFormField(
                                                controller: _paydate,
                                                decoration:
                                                    const InputDecoration(
                                                  //labelText: cust.date,
                                                  border: OutlineInputBorder(),
                                                  filled: true,
                                                  prefixIcon: Icon(
                                                      Icons.calendar_today),
                                                ),
                                                readOnly: true,
                                                onTap: () {
                                                  _payDate(DateTime.now()
                                                      .toString()
                                                      .split(" ")[0]);
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.grey),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Cancel")),
                                        ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                Database(uid: user!.uid)
                                                    .updatePayment(true, id,
                                                        paydate, payAmount);
                                              });

                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: Text("Confirm")),
                                      ],
                                    ));
                          },
                          icon: const Icon(Icons.add)),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: custUpdate.paydate.length,
                        itemBuilder: (BuildContext context, int index) {
                          String key = custUpdate.paydate.keys.elementAt(index);
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "$key : ${custUpdate.paydate[key]}",
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                                  title: const Text(
                                                      "Are you sure to delete?"),
                                                  actions: [
                                                    ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .grey),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Cancel")),
                                                    ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .red),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            Database(
                                                                    uid: user!
                                                                        .uid)
                                                                .deleteDate(
                                                                    id, key);
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Confirm")),
                                                  ],
                                                ));
                                      },
                                      icon: const Icon(Icons.delete)),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        }),
        actions: <Widget>[
          SizedBox(
            width: 150.0,
            height: 40.0,
            child: ElevatedButton.icon(
              onPressed: () {
                if (customerKey.currentState!.validate()) {
                  custUpdate.name = custUpdate.name!.toLowerCase();
                  custUpdate.address = custUpdate.address!.toLowerCase();
                  custUpdate.boxnumber = custUpdate.boxnumber!.toLowerCase();

                  Database(uid: user!.uid).updateCustomer(custUpdate, id);

                  Navigator.of(ctx).pop();
                }
              },
              icon: const Icon(Icons.update, size: 18),
              label: const Text(
                "Update",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool ismob = width <= 600 ? true : false;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add Customer"),
        icon: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Enter Customer Details"),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Container(
                  width: 600,
                  child: Form(
                    key: customerKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 20, 20),
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "enter name";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      customer.name = val;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text("Name"),
                                      hintText: "Enter customer name",
                                      icon: Icon(Icons.person)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 20, 20),
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "enter box number";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      customer.boxnumber = val;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text("Box Number"),
                                      hintText: "Enter box Number",
                                      icon: Icon(Icons.dvr)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 20, 20),
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Enter Phone number";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      customer.phonenumber = val;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text("Phone Number"),
                                      hintText: "Enter phone number",
                                      icon: Icon(Icons.phone)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 20, 20),
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "enter package amount";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      customer.package = val;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text("Package amount"),
                                      hintText: "Enter package amount",
                                      icon: Icon(Icons.currency_rupee)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 20, 20),
                          child: TextFormField(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "enter address";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                customer.address = val;
                              });
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Address"),
                                hintText: "Enter Address",
                                icon: Icon(Icons.location_city_rounded)),
                          ),
                        ),
                        Row(
                          children: [
                            const Text("Connection Status : "),
                            Switch(
                              onChanged: (val) {
                                setState(() {
                                  customer.isconnected = val;
                                });
                              },
                              value: customer.isconnected,
                              activeColor: Colors.green,
                              activeTrackColor: Colors.greenAccent,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 20, 20),
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Select date";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: _datecontrol,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Connection Date',
                                    filled: true,
                                    prefixIcon: Icon(Icons.calendar_today),
                                  ),
                                  readOnly: true,
                                  onTap: () {
                                    _selectDate();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Payment Status : "),
                            Switch(
                              onChanged: (val) {
                                if (val) {
                                  setState(() {
                                    customer.paydate = {
                                      DateTime.now().toString().split(" ")[0]:
                                          customer.package
                                    };
                                    customer.ispaid = val;
                                  });
                                } else {
                                  setState(() {
                                    customer.ispaid = val;
                                    customer.paydate.clear();
                                  });
                                }
                              },
                              value: customer.ispaid,
                              activeColor: Colors.green,
                              activeTrackColor: Colors.greenAccent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              actions: <Widget>[
                SizedBox(
                  width: 100.0,
                  height: 40.0,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (customerKey.currentState!.validate()) {
                        customer.name = customer.name!.toLowerCase();
                        customer.address = customer.address!.toLowerCase();
                        customer.boxnumber = customer.boxnumber!.toLowerCase();

                        Database(uid: user!.uid).createCustomer(customer);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Loading()));
                      }
                    },
                    icon: const Icon(
                      Icons.save_alt,
                      size: 18,
                    ),
                    label: const Text(
                      "Save",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: customersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return Form(
            key: homeKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                              width * 0.15, 40, width * 0.01, 40),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Search",
                                hintText: "Search...",
                                icon: Icon(Icons.search),
                                focusedBorder: OutlineInputBorder()),
                            onChanged: (val) {
                              setState(() {
                                name = val;
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            width * 0.01, 40, width * 0.01, 40),
                        child: SizedBox(
                          // width: 125,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (value == '1') {
                                  customersStream = FirebaseFirestore.instance
                                      .collection(
                                          'Users/${user!.uid}/Customers')
                                      .where('Name',
                                          isGreaterThanOrEqualTo:
                                              name.toLowerCase(),
                                          isLessThan: name.substring(
                                                  0, name.length - 1) +
                                              String.fromCharCode(
                                                  name.codeUnitAt(
                                                          name.length - 1) +
                                                      1))
                                      .snapshots();
                                } else if (value == '2') {
                                  customersStream = FirebaseFirestore.instance
                                      .collection(
                                          'Users/${user!.uid}/Customers')
                                      .where('BoxNumber',
                                          isGreaterThanOrEqualTo:
                                              name.toLowerCase(),
                                          isLessThan: name.substring(
                                                  0, name.length - 1) +
                                              String.fromCharCode(
                                                  name.codeUnitAt(
                                                          name.length - 1) +
                                                      1))
                                      .snapshots();
                                } else if (value == '3') {
                                  customersStream = FirebaseFirestore.instance
                                      .collection(
                                          'Users/${user!.uid}/Customers')
                                      .where('Address',
                                          isGreaterThanOrEqualTo:
                                              name.toLowerCase(),
                                          isLessThan: name.substring(
                                                  0, name.length - 1) +
                                              String.fromCharCode(
                                                  name.codeUnitAt(
                                                          name.length - 1) +
                                                      1))
                                      .snapshots();
                                } else if (value == '-1') {
                                  customersStream = FirebaseFirestore.instance
                                      .collection(
                                          'Users/${user!.uid}/Customers')
                                      .snapshots();
                                } else if (value == '4') {
                                  customersStream = FirebaseFirestore.instance
                                      .collection(
                                          'Users/${user!.uid}/Customers')
                                      .where('Connection', isEqualTo: true)
                                      .snapshots();
                                } else if (value == '5') {
                                  customersStream = FirebaseFirestore.instance
                                      .collection(
                                          'Users/${user!.uid}/Customers')
                                      .where('Connection', isEqualTo: false)
                                      .snapshots();
                                } else if (value == '6') {
                                  customersStream = FirebaseFirestore.instance
                                      .collection(
                                          'Users/${user!.uid}/Customers')
                                      .where('Payment', isEqualTo: true)
                                      .snapshots();
                                } else if (value == '7') {
                                  customersStream = FirebaseFirestore.instance
                                      .collection(
                                          'Users/${user!.uid}/Customers')
                                      .where('Payment', isEqualTo: false)
                                      .snapshots();
                                } else {
                                  customersStream = FirebaseFirestore.instance
                                      .collection(
                                          'Users/${user!.uid}/Customers')
                                      .where('Pending', isEqualTo: true)
                                      .snapshots();
                                }
                              });
                            },
                            child: const Text(
                              "Search",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            width * 0.01, 40, width * 0.01, 40),
                        child: const Text(
                          'Search by:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                              width * 0.01, 40, width * 0.15, 40),
                          child: DropdownButtonFormField(
                              focusColor: null,
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(),
                              ),
                              value: value,
                              items: const [
                                DropdownMenuItem(
                                  value: "-1",
                                  child: Text("All"),
                                ),
                                DropdownMenuItem(
                                  value: "1",
                                  child: Text("By Name"),
                                ),
                                DropdownMenuItem(
                                  value: "2",
                                  child: Text("By Box number"),
                                ),
                                DropdownMenuItem(
                                  value: "3",
                                  child: Text("By Address"),
                                ),
                                DropdownMenuItem(
                                  value: "4",
                                  child: Text("Connected"),
                                ),
                                DropdownMenuItem(
                                  value: "5",
                                  child: Text("Not Connected"),
                                ),
                                DropdownMenuItem(
                                  value: "6",
                                  child: Text("Paid"),
                                ),
                                DropdownMenuItem(
                                  value: "7",
                                  child: Text("Not paid"),
                                ),
                                DropdownMenuItem(
                                  value: "8",
                                  child: Text("Pending"),
                                ),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  value = val!;
                                });
                              }),
                        ),
                      ),
                    ],
                  ),
                  DataTable(
                    horizontalMargin: 0,
                    columnSpacing: 0,
                    border: TableBorder.all(
                      color: Colors.black,
                    ),
                    columns: const [
                      DataColumn(
                          label: Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Text('Name',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      )),
                      DataColumn(
                          label: Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Text('Setup box number',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      )),
                      DataColumn(
                          label: Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Text('Address',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      )),
                      DataColumn(
                          label: Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Text('Connection status',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      )),
                      DataColumn(
                          label: Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 25, 5),
                        child: Text('Payment status',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      )),
                    ],
                    rows: snapshot.data!.docs.map((DocumentSnapshot document) {
                      // print(snapshot.data!.docs.length);
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      return DataRow(cells: [
                        DataCell(
                          onDoubleTap: () {
                            custUpdate.name = data['Name'];
                            custUpdate.boxnumber = data['BoxNumber'];
                            custUpdate.address = data['Address'];
                            custUpdate.date = data['ConnectAt'];
                            custUpdate.isconnected = data['Connection'];
                            custUpdate.ispaid = data['Payment'];
                            custUpdate.package = data['Package'];
                            custUpdate.phonenumber = data['PhoneNumber'];
                            custUpdate.paydate = data['Paydate'];
                            custUpdate.pending = data['Pending'];

                            updateBox(custUpdate, document.id);
                          },
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                            child: Text(
                              data['Name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataCell(onDoubleTap: () {
                          custUpdate.name = data['Name'];
                          custUpdate.boxnumber = data['BoxNumber'];
                          custUpdate.address = data['Address'];
                          custUpdate.date = data['ConnectAt'];
                          custUpdate.isconnected = data['Connection'];
                          custUpdate.ispaid = data['Payment'];
                          custUpdate.package = data['Package'];
                          custUpdate.phonenumber = data['PhoneNumber'];
                          custUpdate.paydate = data['Paydate'];
                          custUpdate.pending = data['Pending'];

                          updateBox(custUpdate, document.id);
                        },
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                              child: Text(data['BoxNumber']),
                            )),
                        DataCell(onDoubleTap: () {
                          custUpdate.name = data['Name'];
                          custUpdate.boxnumber = data['BoxNumber'];
                          custUpdate.address = data['Address'];
                          custUpdate.date = data['ConnectAt'];
                          custUpdate.isconnected = data['Connection'];
                          custUpdate.ispaid = data['Payment'];
                          custUpdate.package = data['Package'];
                          custUpdate.phonenumber = data['PhoneNumber'];
                          custUpdate.paydate = data['Paydate'];
                          custUpdate.pending = data['Pending'];

                          updateBox(custUpdate, document.id);
                        },
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                              child: Text(data['Address'] ?? "not found"),
                            )),
                        DataCell(onDoubleTap: () {
                          custUpdate.name = data['Name'];
                          custUpdate.boxnumber = data['BoxNumber'];
                          custUpdate.address = data['Address'];
                          custUpdate.date = data['ConnectAt'];
                          custUpdate.isconnected = data['Connection'];
                          custUpdate.ispaid = data['Payment'];
                          custUpdate.package = data['Package'];
                          custUpdate.phonenumber = data['PhoneNumber'];
                          custUpdate.paydate = data['Paydate'];
                          custUpdate.pending = data['Pending'];

                          updateBox(custUpdate, document.id);
                        },
                            Center(
                              child: Switch(
                                onChanged: (val) {
                                  setState(() {
                                    Database(uid: user!.uid)
                                        .updateConnection(val, document.id);
                                  });
                                },
                                value: data['Connection'],
                                activeColor: Colors.green,
                                activeTrackColor: Colors.greenAccent,
                              ),
                            )),
                        DataCell(onTap: () {
                          Database(uid: user!.uid)
                              .updatePending(document.id, !data['Pending']);
                        },
                            Container(
                              padding: const EdgeInsets.fromLTRB(15, 5, 25, 5),
                              width: double.infinity,
                              color: data['Pending'] == true
                                  ? Colors.orangeAccent
                                  : Colors.white,
                              child: Row(
                                children: [
                                  Checkbox(
                                    onChanged: (val) {
                                      if (val == true) {
                                        if (amount == " ") {
                                          setState(() {
                                            Database(uid: user!.uid)
                                                .updatePayment(
                                                    val!,
                                                    document.id,
                                                    DateTime.now()
                                                        .toString()
                                                        .split(" ")[0],
                                                    data['Package']);
                                          });
                                        } else {
                                          setState(() {
                                            Database(uid: user!.uid)
                                                .updatePayment(
                                                    val!,
                                                    document.id,
                                                    DateTime.now()
                                                        .toString()
                                                        .split(" ")[0],
                                                    amount);
                                            amount = " ";
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          Database(uid: user!.uid)
                                              .updatePayment(
                                                  val!,
                                                  document.id,
                                                  DateTime.now()
                                                      .toString()
                                                      .split(" ")[0],
                                                  data['Package']);
                                        });
                                      }
                                    },
                                    value: data['Payment'],
                                    activeColor: Colors.green,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        initialValue: data['Package'],
                                        onChanged: (value) {
                                          setState(() {
                                            amount = value;
                                          });
                                        },
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ))
                      ]);
                    }).toList(),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        auth.Signout();
                      },
                      child: Text("Log out")),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Database(uid: user!.uid).clearPayment();
                      },
                      child: Text("Clear payments")),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
