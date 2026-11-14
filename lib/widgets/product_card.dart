import 'package:flutter/material.dart';
import 'package:smart_pantry/models/product.dart';
import 'package:smart_pantry/core/theme/app_colors.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  int get _daysLeft {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return product.expirationDate.difference(today).inDays;
  }

  String get _expiryText {
    if (_daysLeft < 0) return 'Expired';
    if (_daysLeft == 0) return 'Expires today';
    if (_daysLeft == 1) return 'Expires tomorrow';
    return 'Expires in $_daysLeft days';
  }

  String get _statusLabel {
    if (_daysLeft < 0) return 'Expired';
    if (_daysLeft <= 3) return 'Expiring soon';
    if (_daysLeft <= 7) return 'Use soon';
    return 'Fresh';
  }

  Color get _statusColor {
    if (_daysLeft < 0) return AppColors.dangerRed;
    if (_daysLeft <= 7) return AppColors.warningOrange;
    return AppColors.primaryGreen;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final qty = product.quantity % 1 == 0
        ? product.quantity.toInt().toString()
        : product.quantity.toString();

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.shopping_basket_outlined,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      '${product.category} · $qty ${product.unit}',
                      style: textTheme.bodySmall,
                    ),
                    Text(_expiryText, style: textTheme.bodySmall),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _statusColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}