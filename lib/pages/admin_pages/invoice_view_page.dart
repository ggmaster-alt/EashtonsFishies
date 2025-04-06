import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminCheck extends StatelessWidget {
  const AdminCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Area'),
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          final user = snapshot.data;
          if (user == null) {
            return _buildAccessDenied(context, 'Please sign in to access admin features');
          }
          
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError) {
                return _buildAccessDenied(context, 'Error checking permissions');
              }
              
              final userData = snapshot.data?.data() as Map<String, dynamic>?;
              final isAdmin = userData?['isAdmin'] == true;
              
              if (!isAdmin) {
                return _buildAccessDenied(context, 'You do not have admin access');
              }
              
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      size: 80,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Admin Dashboard',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),
                    _buildAdminButton(
                      context,
                      'Order Management',
                      Icons.receipt_long,
                      'View and manage customer orders',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminInvoiceManagementPage(),
                          ),
                        );
                      }
                    ),
                    // Add more admin features as needed
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
  
  Widget _buildAccessDenied(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.no_accounts,
            size: 80,
            color: Colors.red,
          ),
          SizedBox(height: 16),
          Text(
            'Access Denied',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(message),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Go Back'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAdminButton(
    BuildContext context,
    String title,
    IconData icon,
    String description,
    VoidCallback onPressed,
  ) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue[100],
                child: Icon(
                  icon,
                  color: Colors.blue,
                  size: 26,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}



class Invoice {
  final String id;
  final String name;
  final String phonenumber;
  final String postcode;
  final String address;
  final String town;
  final double totalAmount;
  final bool status;
  final List<Map<String, dynamic>> items;
  final DateTime? timestamp;
  final String userId;

  Invoice({
    required this.id,
    required this.name,
    required this.phonenumber,
    required this.postcode,
    required this.address,
    required this.town,
    required this.totalAmount,
    required this.status,
    required this.items,
    this.timestamp,
    required this.userId,
  });

  factory Invoice.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Invoice(
      id: doc.id,
      name: data['name'] ?? '',
      phonenumber: data['phonenumber'] ?? '',
      postcode: data['postcode'] ?? '',
      address: data['address'] ?? '',
      town: data['town'] ?? '',
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      status: data['status'] ?? false,
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
      userId: data['userId'] ?? '',
    );
  }
}

class AdminInvoiceManagementPage extends StatefulWidget {
  const AdminInvoiceManagementPage({Key? key}) : super(key: key);

  @override
  _AdminInvoiceManagementPageState createState() => _AdminInvoiceManagementPageState();
}

class _AdminInvoiceManagementPageState extends State<AdminInvoiceManagementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _toggleInvoiceStatus(String invoiceId, bool currentStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('invoices')
          .doc(invoiceId)
          .update({'status': !currentStatus});
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(currentStatus 
              ? 'Order marked as pending' 
              : 'Order marked as completed'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update order status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteInvoice(String invoiceId) async {
    try {
      await FirebaseFirestore.instance
          .collection('invoices')
          .doc(invoiceId)
          .delete();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Pending Orders'),
            Tab(text: 'Completed Orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Pending Invoices (status = false)
          _buildInvoicesList(false),
          
          // Tab 2: Completed Invoices (status = true)
          _buildInvoicesList(true),
        ],
      ),
    );
  }

  Widget _buildInvoicesList(bool status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('invoices')
          .where('status', isEqualTo: status)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    status ? Icons.check_circle_outline : Icons.pending_actions,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No ${status ? "completed" : "pending"} orders found',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        }
        
        final invoices = snapshot.data!.docs
            .map((doc) => Invoice.fromFirestore(doc))
            .toList();
        
        return ListView.builder(
          itemCount: invoices.length,
          padding: EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final invoice = invoices[index];
            final displayDate = invoice.timestamp != null
                ? DateFormat('dd/MM/yyyy HH:mm').format(invoice.timestamp!)
                : 'Pending';
            
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: status ? Colors.green.shade300 : Colors.orange.shade300,
                  width: 1,
                ),
              ),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: status ? Colors.green.shade100 : Colors.orange.shade100,
                  child: Icon(
                    status ? Icons.check_circle : Icons.pending,
                    color: status ? Colors.green : Colors.orange,
                  ),
                ),
                title: Text(
                  invoice.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '£${invoice.totalAmount.toStringAsFixed(2)} • $displayDate',
                ),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Phone', invoice.phonenumber),
                        _buildInfoRow('Address', '${invoice.address}, ${invoice.town}'),
                        _buildInfoRow('Postcode', invoice.postcode),
                        SizedBox(height: 16),
                        
                        Text('Order Items', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Divider(),
                        
                        ...invoice.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Text('${item['quantity']}x', 
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 8),
                              Expanded(child: Text(item['name'])),
                              Text('£${(item['price'] * item['quantity']).toStringAsFixed(2)}'),
                            ],
                          ),
                        )).toList(),
                        
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total', 
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '£${invoice.totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(status ? Icons.replay : Icons.check_circle),
                                label: Text(status ? 'Mark as Pending' : 'Complete Order'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: status ? Colors.blue : Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () => _toggleInvoiceStatus(invoice.id, status),
                              ),
                            ),
                            if (!status) SizedBox(width: 8),
                            if (!status)
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: Icon(Icons.delete),
                                  label: Text('Delete Order'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Confirm Deletion'),
                                        content: Text('Are you sure you want to delete this order? This action cannot be undone.'),
                                        actions: [
                                          TextButton(
                                            child: Text('Cancel'),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.red,
                                            ),
                                            child: Text('Delete'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _deleteInvoice(invoice.id);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}