import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalAmount;
  const CheckoutScreen({super.key, required this.totalAmount});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedPayment = 'Cash on Delivery';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shipping Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter phone number' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Delivery Address',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter address' : null,
              ),
              const SizedBox(height: 24),
              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedPayment,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.payment_outlined),
                ),
                items: ['Cash on Delivery', 'bKash / Mobile Banking', 'Credit / Debit Card']
                    .map((method) => DropdownMenuItem(value: method, child: Text(method)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedPayment = val!),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Payable Amount:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      Text(
                        '\$${widget.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Save order to history
                      final newOrder = OrderItem(
                        orderId: DateTime.now().millisecondsSinceEpoch.toString().substring(7),
                        items: List.from(cart.items),
                        totalAmount: widget.totalAmount,
                        name: _nameController.text,
                        phone: _phoneController.text,
                        address: _addressController.text,
                        paymentMethod: _selectedPayment,
                        date: DateTime.now(),
                      );
                      orderHistory.addOrder(newOrder);

                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Order Placed Successfully! 🎉'),
                          content: Text(
                            'Thank you, ${_nameController.text}!\nYour order will be shipped to ${_addressController.text}.\nTotal: \$${widget.totalAmount.toStringAsFixed(2)} via $_selectedPayment.',
                          ),
                          actions: [
                            FilledButton(
                              onPressed: () {
                                cart.clear();
                                Navigator.pop(ctx); // pop dialog
                                Navigator.pop(context); // pop checkout
                                Navigator.pop(context); // pop cart
                              },
                              child: const Text('Done'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Confirm Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
