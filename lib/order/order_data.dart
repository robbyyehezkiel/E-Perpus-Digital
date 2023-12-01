import 'package:flutter/material.dart';
import 'package:e_perpus_app/data/order.dart';
import 'package:e_perpus_app/database_helper.dart';
import 'package:e_perpus_app/order/order_detail.dart';
import 'package:intl/intl.dart';

class OrderDataPage extends StatelessWidget {
  const OrderDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 94, 204, 255),
        title: const Text(
          'Order Data',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: OrderList(),
      ),
    );
  }
}

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  late Future<List<Order>> orders;

  @override
  void initState() {
    super.initState();
    refreshOrderList();
  }

  Future<void> refreshOrderList() async {
    setState(() {
      orders = fetchOrdersFromDatabaseAsync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: orders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final orderData = snapshot.data ?? [];
          if (orderData.isEmpty) {
            return Center(child: Text('No orders available.'));
          } else {
            return _buildOrderListView(orderData);
          }
        }
      },
    );
  }

  Widget _buildOrderListView(List<Order> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (BuildContext context, int index) {
        final order = orders[index];
        return _buildOrderCard(context, order);
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    String formattedOrderTime =
        dateFormat.format(order.orderTime ?? DateTime.now());
    String formattedReturnTime =
        dateFormat.format(order.returnTime ?? DateTime.now());

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderDetailPage(
              orderData: {
                'orderTime': formattedOrderTime,
                'returnTime': formattedReturnTime,
              },
              memberNIM: order.memberNIM,
              workerNIP: order.workerNIP,
              bookId: order.bookId,
            ),
          ),
        );
      },
      child: FutureBuilder<String?>(
        future: fetchMemberName(order.memberNIM),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListTile(
              title: const Text('Member: Loading...'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Order Time: $formattedOrderTime'),
                  Text('Return Time: $formattedReturnTime'),
                ],
              ),
            );
          } else {
            final memberName = snapshot.data;
            return Card(
              elevation: 4.0,
              child: ListTile(
                title: Text('Member: ${memberName ?? 'Unknown'}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Order Time: $formattedOrderTime'),
                    Text('Return Time: $formattedReturnTime'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, order.orderId);
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<String?> fetchMemberName(String? memberNIM) async {
    final dbHelper = DatabaseHelper();
    return dbHelper.getMemberNameByNIM(memberNIM);
  }

  Future<List<Order>> fetchOrdersFromDatabaseAsync() async {
    final dbHelper = DatabaseHelper();
    return dbHelper.getOrders();
  }

  void _showDeleteConfirmationDialog(BuildContext context, int? orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this order?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                final dbHelper = DatabaseHelper();
                final result = await dbHelper.deleteOrder(orderId);

                if (result != 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order deleted successfully.'),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  refreshOrderList();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error deleting order.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
