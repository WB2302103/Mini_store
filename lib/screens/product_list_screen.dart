import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/wishlist_model.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../main.dart';
import 'cart_screen.dart';
import 'wishlist_screen.dart';
import 'product_detail_screen.dart';
import 'profile_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _futureProducts;
  List<Product> _allProducts = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _sortBy = 'Default';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    _futureProducts = ApiService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade900 : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('MiniStore', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
        surfaceTintColor: Colors.transparent,
        actions: [
          // Theme Toggle button
          ListenableBuilder(
            listenable: themeNotifier,
            builder: (context, _) {
              return IconButton(
                icon: Icon(themeNotifier.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                onPressed: () => themeNotifier.toggleTheme(),
              );
            },
          ),
          // Profile icon button
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
          // Wishlist icon button
          ListenableBuilder(
            listenable: wishlist,
            builder: (context, _) {
              return Badge(
                isLabelVisible: wishlist.items.isNotEmpty,
                label: Text('${wishlist.items.length}'),
                child: IconButton(
                  icon: const Icon(Icons.favorite_outline),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WishlistScreen()),
                  ),
                ),
              );
            },
          ),
          // Cart icon button
          ListenableBuilder(
            listenable: cart,
            builder: (context, _) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Badge(
                  isLabelVisible: cart.totalQuantity > 0,
                  label: Text('${cart.totalQuantity}'),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('Could not load products'),
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: () => setState(() => _loadProducts()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          _allProducts = snapshot.data!;
          final categories = ['All', ..._allProducts.map((p) => p.category).toSet()];

          // Filtering
          var filteredProducts = _allProducts.where((p) {
            final matchesSearch = p.title.toLowerCase().contains(_searchQuery.toLowerCase());
            final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
            return matchesSearch && matchesCategory;
          }).toList();

          // Sorting
          if (_sortBy == 'Price: Low to High') {
            filteredProducts.sort((a, b) => a.price.compareTo(b.price));
          } else if (_sortBy == 'Price: High to Low') {
            filteredProducts.sort((a, b) => b.price.compareTo(a.price));
          } else if (_sortBy == 'Rating') {
            filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 2;
              if (constraints.maxWidth > 1200) {
                crossAxisCount = 5;
              } else if (constraints.maxWidth > 900) {
                crossAxisCount = 4;
              } else if (constraints.maxWidth > 600) {
                crossAxisCount = 3;
              }

              return RefreshIndicator(
                onRefresh: () async => setState(() => _loadProducts()),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: Column(
                            children: [
                              // Promotional Banner
                              Container(
                                margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                                height: 140,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Mega Summer Sale! 🛍️',
                                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        'Get up to 40% off on top electronics & fashion items.',
                                        style: TextStyle(color: Colors.white70, fontSize: 12),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          'Explore Now',
                                          style: TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold, fontSize: 11),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Search & Sort row
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Search products...',
                                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                                          filled: true,
                                          fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                        ),
                                        onChanged: (val) => setState(() => _searchQuery = val),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: const Color(0xFFE5E7EB)),
                                      ),
                                      child: PopupMenuButton<String>(
                                        icon: const Icon(Icons.sort),
                                        onSelected: (val) => setState(() => _sortBy = val),
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(value: 'Default', child: Text('Default')),
                                          const PopupMenuItem(value: 'Price: Low to High', child: Text('Price: Low to High')),
                                          const PopupMenuItem(value: 'Price: High to Low', child: Text('Price: High to Low')),
                                          const PopupMenuItem(value: 'Rating', child: Text('Top Rated')),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Category Chips
                              SizedBox(
                                height: 42,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  itemCount: categories.length,
                                  itemBuilder: (context, index) {
                                    final cat = categories.elementAt(index);
                                    final isSelected = cat == _selectedCategory;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: ChoiceChip(
                                        label: Text(cat[0].toUpperCase() + cat.substring(1)),
                                        selected: isSelected,
                                        selectedColor: Theme.of(context).colorScheme.primaryContainer,
                                        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        side: BorderSide(color: isSelected ? Colors.transparent : const Color(0xFFE5E7EB)),
                                        onSelected: (_) => setState(() => _selectedCategory = cat),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                    filteredProducts.isEmpty
                        ? const SliverFillRemaining(
                            child: Center(child: Text('No products found')),
                          )
                        : SliverPadding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            sliver: SliverGrid(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: 0.72,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => _ProductCard(product: filteredProducts[index]),
                                childCount: filteredProducts.length,
                              ),
                            ),
                          ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 0,
      color: isDark ? const Color(0xFF1F2937) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isDark ? Colors.grey.shade800 : const Color(0xFFE5E7EB), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    Center(
                      child: Hero(
                        tag: 'product-${product.id}',
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            product.image,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image, size: 40),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: ListenableBuilder(
                        listenable: wishlist,
                        builder: (context, _) {
                          final isFav = wishlist.isInWishlist(product.id);
                          return Container(
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey.shade800.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.red : Colors.grey.shade600,
                                size: 18,
                              ),
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                              onPressed: () => wishlist.toggle(product),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: isDark ? Colors.white70 : Colors.black87),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  Text(' ${product.rating}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: isDark ? Colors.white60 : Colors.black54)),
                ],
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                height: 32,
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    cart.add(product);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text('Added to cart'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                  },
                  child: const Text('Add to cart', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
