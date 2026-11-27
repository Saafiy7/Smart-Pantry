import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../models/food_info.dart';
import 'open_food_facts_search_screen.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;
  const AddProductScreen({super.key, this.product});

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
  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();

    final product = widget.product;
    if (product == null) return;

    _nameController.text = product.name;
    _brandController.text = product.brand;
    _quantityController.text = product.quantity % 1 == 0
        ? product.quantity.toInt().toString()
        : product.quantity.toString();
    _selectedDate = product.expirationDate;
    _dateController.text = _formatDate(product.expirationDate);
    _selectedCategory = product.category;
    _selectedUnit = product.unit;
    _selectedLocation = product.storageLocation;
    _imageUrl = product.imageUrl;

    if (!_categories.contains(_selectedCategory)) {
      _categories.add(_selectedCategory);
    }
    if (!_units.contains(_selectedUnit)) {
      _units.add(_selectedUnit);
    }
    if (!_locations.contains(_selectedLocation)) {
      _locations.add(_selectedLocation);
    }
  }

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

    final Product result;
    if (_isEditing) {
      result = widget.product!.copyWith(
        name: _nameController.text.trim(),
        category: _selectedCategory,
        brand: _brandController.text.trim(),
        quantity: quantity,
        unit: _selectedUnit,
        storageLocation: _selectedLocation,
        expirationDate: _selectedDate,
        imageUrl: _imageUrl,
      );
    } else {
      result = Product(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        category: _selectedCategory,
        brand: _brandController.text.trim(),
        quantity: quantity,
        unit: _selectedUnit,
        storageLocation: _selectedLocation,
        expirationDate: _selectedDate!,
        imageUrl: _imageUrl,
      );
    }
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit product' : 'Add product')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_isEditing) ...[
                  CustomButton(
                    label: 'Search with Open Food Facts',
                    icon: Icons.search,
                    isSecondary: true,
                    onPressed: _searchOpenFoodFacts,
                  ),
                  const SizedBox(height: 24),
                ],
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
                CustomButton(
                  label: _isEditing ? 'Save changes' : 'Save product',
                  onPressed: _saveProduct,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
