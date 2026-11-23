import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../models/food_info.dart';
import 'open_food_facts_search_screen.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _dateController = TextEditingController();

  final List<String> _categories = [
    'Dairy',
    'Fruits & Vegetables',
    'Meat & Fish',
    'Drinks',
    'Pantry',
    'Other',
  ];
  final List<String> _units = ['pcs', 'kg', 'g', 'L', 'ml'];
  final List<String> _locations = ['Fridge', 'Freezer', 'Pantry'];

  String _selectedCategory = 'Dairy';
  String _selectedUnit = 'pcs';
  String _selectedLocation = 'Fridge';
  DateTime? _selectedDate;
  String? _imageUrl;

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _quantityController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );

    if (picked == null || !mounted) return;

    setState(() {
      _selectedDate = picked;
      _dateController.text = _formatDate(picked);
    });
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Product name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must contain at least 2 characters';
    }
    return null;
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required';
    }
    final quantity = double.tryParse(value.trim().replaceAll(',', '.'));
    if (quantity == null) {
      return 'Enter a valid number';
    }
    if (quantity <= 0) {
      return 'Quantity must be greater than 0';
    }
    return null;
  }

  String? _validateDate(String? value) {
    if (_selectedDate == null) {
      return 'Expiration date is required';
    }
    return null;
  }

  Future<void> _searchOpenFoodFacts() async {
    final result = await Navigator.push<FoodInfo>(
      context,
      MaterialPageRoute(
        builder: (context) => const OpenFoodFactsSearchScreen(),
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      _nameController.text = result.name;
      _brandController.text = result.brand;
      _imageUrl = result.imageUrl;
    });
  }

  void _saveProduct() {
    if (!_formKey.currentState!.validate()) return;

    final quantity = double.parse(
      _quantityController.text.trim().replaceAll(',', '.'),
    );

    final product = Product(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      category: _selectedCategory,
      brand: _brandController.text.trim(),
      quantity: quantity,
      unit: _selectedUnit,
      storageLocation: _selectedLocation,
      expirationDate: _selectedDate!,
    );

    Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Add product')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomButton(
                  label: 'Search with Open Food Facts',
                  icon: Icons.search,
                  isSecondary: true,
                  onPressed:  _searchOpenFoodFacts,
                ),
                if (_imageUrl != null) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _imageUrl!,
                        height: 120,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.image_not_supported_outlined,
                              size: 48,
                            ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Text('Product information', style: textTheme.titleMedium),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Product name',
                  controller: _nameController,
                  prefixIcon: Icons.shopping_basket_outlined,
                  validator: _validateName,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Brand (optional)',
                  controller: _brandController,
                  prefixIcon: Icons.sell_outlined,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Quantity',
                  controller: _quantityController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  prefixIcon: Icons.numbers,
                  validator: _validateQuantity,
                ),
                const SizedBox(height: 16),
                Text('Unit', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _units.map((unit) {
                    return ChoiceChip(
                      label: Text(unit),
                      selected: _selectedUnit == unit,
                      selectedColor: AppColors.lightGreen,
                      onSelected: (_) {
                        setState(() {
                          _selectedUnit = unit;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Expiration date',
                  controller: _dateController,
                  readOnly: true,
                  prefixIcon: Icons.calendar_today_outlined,
                  onTap: _pickDate,
                  validator: _validateDate,
                ),
                const SizedBox(height: 24),
                Text('Category', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories.map((category) {
                    return ChoiceChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      selectedColor: AppColors.lightGreen,
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Text('Storage location', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: _locations.map((location) {
                    return ButtonSegment<String>(
                      value: location,
                      label: Text(location),
                    );
                  }).toList(),
                  selected: {_selectedLocation},
                  onSelectionChanged: (selection) {
                    setState(() {
                      _selectedLocation = selection.first;
                    });
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(label: 'Save product', onPressed: _saveProduct),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
