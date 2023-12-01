import 'package:e_perpus_app/data/book.dart';
import 'package:e_perpus_app/data/member.dart';
import 'package:e_perpus_app/data/order.dart';
import 'package:e_perpus_app/data/worker.dart';
import 'package:e_perpus_app/database_helper.dart';
import 'package:e_perpus_app/order/order_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({Key? key}) : super(key: key);

  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  late TextEditingController memberController;
  late TextEditingController bookController;

  bool _isAddingOrder = false;

  List<Member> members = [];
  List<Worker> workers = [];
  List<Book> books = [];

  String? selectedMemberNIM;
  String? selectedWorkerNIP;
  String? selectedBookId;
  DateTime? selectedOrderTime;
  DateTime? selectedReturnTime;
  @override
  void initState() {
    super.initState();
    memberController = TextEditingController();
    bookController = TextEditingController();
    fetchDataFromDatabase(); // Call this method to load data from the database.
  }

  Future<void> fetchDataFromDatabase() async {
    final dbHelper = DatabaseHelper();

    // Fetch members, workers, and books from the database
    final membersFromDB = await dbHelper.getMembers();
    final workersFromDB = await dbHelper.getWorkers();
    final booksFromDB = await dbHelper.getBooks();

    setState(() {
      members = membersFromDB;
      workers = workersFromDB;
      books = booksFromDB;
    });
  }

  Future<void> addOrderToDatabase() async {
    if (selectedMemberNIM == null ||
        selectedWorkerNIP == null ||
        selectedBookId == null ||
        selectedOrderTime == null ||
        selectedReturnTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isAddingOrder = true;
    });

    // Create an Order object with the selected data
    final Order order = Order(
      memberNIM: selectedMemberNIM,
      workerNIP: selectedWorkerNIP,
      bookId: selectedBookId,
      orderTime: selectedOrderTime,
      returnTime: selectedReturnTime,
    );

    // Insert the order into the database using the DatabaseHelper
    final DatabaseHelper dbHelper = DatabaseHelper();
    final int result = await dbHelper.insertOrder(order);

    if (result != 0) {
      // Order added successfully
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Order Added Successfully'),
            content: const Text('What do you want to do next?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Tambahkan Data Lainnya'),
                onPressed: () {
                  _resetForm();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Pergi ke Data Pemesanan'),
                onPressed: () {
                  // Navigate to the orders list page
                  Navigator.of(context).pop();
                  navigateToOrderDataPage(); // Call the function to navigate
                },
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error adding order to the database'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      _isAddingOrder = false;
    });
  }

  Future<void> selectOrderTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedOrderTime) {
      setState(() {
        selectedOrderTime = pickedDate;
      });
    }
  }

  Future<void> selectReturnTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedReturnTime) {
      setState(() {
        selectedReturnTime = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 94, 204, 255),
        title: const Text(
          'Create Borrowing Order',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: selectedMemberNIM,
              onChanged: (value) {
                setState(() {
                  selectedMemberNIM = value;
                });
              },
              items: members.map<DropdownMenuItem<String>>(
                (Member member) {
                  return DropdownMenuItem<String>(
                    value: member.nim,
                    child: Text(member.name),
                  );
                },
              ).toList(),
              decoration: const InputDecoration(
                labelText: 'Member',
                border: OutlineInputBorder(),
              ),
              isExpanded: true,
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedWorkerNIP,
              onChanged: (value) {
                setState(() {
                  selectedWorkerNIP = value;
                });
              },
              items: workers.map<DropdownMenuItem<String>>(
                (Worker worker) {
                  return DropdownMenuItem<String>(
                    value: worker.nip,
                    child: Text(worker.name),
                  );
                },
              ).toList(),
              decoration: const InputDecoration(
                labelText: 'Worker',
                border: OutlineInputBorder(),
              ),
              isExpanded: true,
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedBookId,
              onChanged: (value) {
                setState(() {
                  selectedBookId = value;
                });
              },
              items: books.map<DropdownMenuItem<String>>(
                (Book book) {
                  return DropdownMenuItem<String>(
                    value: book.idBook,
                    child: Text(book.title),
                  );
                },
              ).toList(),
              decoration: const InputDecoration(
                labelText: 'Book',
                border: OutlineInputBorder(),
              ),
              isExpanded: true,
            ),
            const SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  'Order Date: ${selectedOrderTime != null ? DateFormat('dd/MM/yyyy').format(selectedOrderTime!) : 'Select Date'}',
                ),
                onTap: selectOrderTime,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  'Return Date: ${selectedReturnTime != null ? DateFormat('dd/MM/yyyy').format(selectedReturnTime!) : 'Select Date'}',
                ),
                onTap: selectReturnTime,
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 56.0,
              child: ElevatedButton(
                onPressed: _isAddingOrder ? null : addOrderToDatabase,
                child: _isAddingOrder
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Add Borrowing Order',
                        style: TextStyle(color: Colors.black),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 94, 204,
                      255), // Button color (replace 'primary' with 'backgroundColor')
                  shadowColor:
                      const Color.fromARGB(255, 94, 204, 255), // Text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToOrderDataPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OrderDataPage(),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      selectedMemberNIM = null;
      selectedWorkerNIP = null;
      selectedBookId = null;
      selectedOrderTime = null;
      selectedReturnTime = null;
    });
  }
}
