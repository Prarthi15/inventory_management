import 'package:flutter/material.dart';
import 'package:inventory_management/Custom-Files/colors.dart';

//warehouse loading animation
class WarehouseLoadingAnimation extends StatefulWidget {
  const WarehouseLoadingAnimation({Key? key}) : super(key: key);

  @override
  _WarehouseLoadingAnimationState createState() =>
      _WarehouseLoadingAnimationState();
}

class _WarehouseLoadingAnimationState extends State<WarehouseLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: Colors.grey.shade400,
      end: AppColors.primaryGreen,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Icon(
            Icons.warehouse_outlined,
            size: 100.0,
            color: _colorAnimation.value,
          ),
        );
      },
    );
  }
}

//prodcut loading animation
class ProductLoadingAnimation extends StatefulWidget {
  const ProductLoadingAnimation({Key? key}) : super(key: key);

  @override
  _ProductLoadingAnimationState createState() =>
      _ProductLoadingAnimationState();
}

class _ProductLoadingAnimationState extends State<ProductLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: Colors.grey.shade400,
      end: AppColors.primaryBlue,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Icon(
            Icons.production_quantity_limits_rounded,
            size: 100.0,
            color: _colorAnimation.value,
          ),
        );
      },
    );
  }
}

//categoyr loading animation
class CategoryLoadingAnimation extends StatefulWidget {
  const CategoryLoadingAnimation({Key? key}) : super(key: key);

  @override
  _CategoryLoadingAnimationState createState() =>
      _CategoryLoadingAnimationState();
}

class _CategoryLoadingAnimationState extends State<CategoryLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: Colors.grey.shade400,
      end: AppColors.primaryBlue,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Icon(
            Icons.category,
            size: 80.0,
            color: _colorAnimation.value,
          ),
        );
      },
    );
  }
}

//inventory loading animation
class InventoryLoadingAnimation extends StatefulWidget {
  const InventoryLoadingAnimation({Key? key}) : super(key: key);

  @override
  _InventoryLoadingAnimationState createState() =>
      _InventoryLoadingAnimationState();
}

class _InventoryLoadingAnimationState extends State<InventoryLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: Colors.grey.shade400,
      end: AppColors.primaryGreen,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Icon(
            Icons.inventory_2,
            size: 80.0,
            color: _colorAnimation.value,
          ),
        );
      },
    );
  }
}
