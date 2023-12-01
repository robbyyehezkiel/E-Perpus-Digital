import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_perpus_app/database_helper.dart'; // Import your DatabaseHelper

class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final String? memberNIM;
  final String? workerNIP;
  final String? bookId;

  const OrderDetailPage({
    Key? key,
    required this.orderData,
    required this.memberNIM,
    required this.workerNIP,
    required this.bookId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 94, 204, 255),
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMemberName(memberNIM),
            _buildWorkerName(workerNIP),
            _buildBookTitle(bookId),
            _buildDetailText(
              'Order Time:',
              _formatDateTime(orderData['orderTime']),
            ),
            _buildDetailText(
              'Return Time:',
              _formatDateTime(orderData['returnTime']),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString != null) {
      final dateTime = DateFormat('dd-MM-yyyy').parse(dateTimeString);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    }
    return '';
  }

  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Container(
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(
              'Date: $value',
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }

  FutureBuilder<String?> _buildMemberName(String? memberNIM) {
    return FutureBuilder<String?>(
      future: DatabaseHelper().getMemberNameByNIM(memberNIM),
      builder: (context, snapshot) {
        final memberName = snapshot.data;
        return _buildTextField('Member:', memberName ?? '');
      },
    );
  }

  FutureBuilder<String?> _buildWorkerName(String? workerNIP) {
    return FutureBuilder<String?>(
      future: DatabaseHelper().getWorkerNameByNIP(workerNIP),
      builder: (context, snapshot) {
        final workerName = snapshot.data;
        return _buildTextField('Worker:', workerName ?? '');
      },
    );
  }

  FutureBuilder<String?> _buildBookTitle(String? bookId) {
    return FutureBuilder<String?>(
      future: DatabaseHelper().getBookTitleById(bookId),
      builder: (context, snapshot) {
        final bookTitle = snapshot.data;
        return _buildTextField('Book:', bookTitle ?? '');
      },
    );
  }
}
