import 'package:flutter/material.dart';
import 'package:smart_pantry/models/product.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _quantityController;
  late final TextEditingController _storageController;
  late final TextEditingController _dateController;
  late DateTime _expirationDate;

  String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
  }

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p.name);
    _brandController = TextEditingController(text: p.brand);
    _quantityController = TextEditingController(
      text: p.quantity % 1 == 0
          ? p.quantity.toInt().toString()
          : p.quantity.toString(),
    );
    _storageController = TextEditingController(text: p.storageLocation);
    _expirationDate = p.expirationDate;
    _dateController = TextEditingController(text: _formatDate(p.expirationDate));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _quantityController.dispose();
    _storageController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expirationDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _expirationDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final quantity = double.parse(
      _quantityController.text.trim().replaceAll(',', '.'),
    );
    final updated = widget.product.copyWith(
      name: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      quantity: quantity,
      storageLocation: _storageController.text.trim(),
      expirationDate: _expirationDate,
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Brand'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Quantity (${widget.product.unit})',
                ),
                validator: (value) {
                  final q = double.tryParse(
                    (value ?? '').trim().replaceAll(',', '.'),
                  );
                  if (q == null || q <= 0) {
                    return 'Enter a quantity greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _storageController,
                decoration: const InputDecoration(labelText: 'Storage location'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a storage location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: 'Expiration date',
                  suffixIcon: Icon(Icons.calendar_today_outlined),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: _save, child: const Text('Save Changes')),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}