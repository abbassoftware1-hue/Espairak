import 'package:flutter/material.dart';

const Color brand = Color(0xFF0F766E);
const Color brandDark = Color(0xFF115E59);
const Color canvas = Color(0xFFF6F8F7);

void main() {
  runApp(const EspairakApp());
}

class EspairakApp extends StatelessWidget {
  const EspairakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'اسبيرك | Espairak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: canvas,
        colorScheme: ColorScheme.fromSeed(seedColor: brand),
        fontFamily: 'Arial',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF172B2A),
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5ECEA)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5ECEA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: brand, width: 1.5),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class Product {
  Product({
    required this.name,
    required this.category,
    required this.price,
    required this.city,
    required this.shop,
    required this.emoji,
    required this.description,
    this.available = true,
    this.verified = false,
  });

  final String name;
  final String category;
  final int price;
  final String city;
  final String shop;
  final String emoji;
  final String description;
  bool available;
  final bool verified;
}

final List<Product> demoProducts = [
  Product(name: 'زيت محرك 4 لتر', category: 'زيوت', price: 110000, city: 'الخرطوم',
      shop: 'متجر الطريق', emoji: '🛢️', description: 'زيت محركات · عبوة 4 لتر', verified: true),
  Product(name: 'بطارية سيارة 60 أمبير', category: 'بطاريات', price: 280000, city: 'أم درمان',
      shop: 'مركز الأمان', emoji: '🔋', description: 'بطارية سيارة · 60Ah', verified: true),
  Product(name: 'فلتر زيت', category: 'قطع غيار', price: 15000, city: 'بحري',
      shop: 'قطع غيار النيل', emoji: '⚙️', description: 'يرجى مطابقة رقم القطعة', verified: false),
  Product(name: 'طقم بواجي سيارة', category: 'كهرباء', price: 42000, city: 'الخرطوم',
      shop: 'كهرباء العربات', emoji: '🔌', description: 'تحقق من التوافق مع موديل السيارة', verified: true),
  Product(name: 'إطار سيارة', category: 'إطارات', price: 195000, city: 'بورتسودان',
      shop: 'إطارات الساحل', emoji: '🛞', description: 'المقاس حسب الطلب', verified: false),
  Product(name: 'فلتر هواء', category: 'قطع غيار', price: 22000, city: 'أم درمان',
      shop: 'مركز الأمان', emoji: '🧰', description: 'يرجى مطابقة رقم القطعة', verified: true),
];

String money(int amount) {
  final s = amount.toString();
  final out = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) out.write('٬');
    out.write(s[i]);
  }
  return '${out.toString()} ج.س';
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = 'الكل';
  String selectedCity = 'كل المدن';
  String sortMode = 'المقترحة';
  final List<Product> products = List<Product>.from(demoProducts);

  final categories = const [
    ('الكل', '▦'),
    ('زيوت', '🛢️'),
    ('قطع غيار', '⚙️'),
    ('بطاريات', '🔋'),
    ('إطارات', '🛞'),
    ('كهرباء', '🔌'),
  ];

  List<Product> get filteredProducts {
    final query = searchController.text.trim().toLowerCase();
    final list = products.where((p) {
      final matchesQuery = query.isEmpty ||
          '${p.name} ${p.category} ${p.shop} ${p.description}'.toLowerCase().contains(query);
      final matchesCategory = selectedCategory == 'الكل' || p.category == selectedCategory;
      final matchesCity = selectedCity == 'كل المدن' || p.city == selectedCity;
      return matchesQuery && matchesCategory && matchesCity;
    }).toList();
    if (sortMode == 'الأقل سعراً') list.sort((a, b) => a.price.compareTo(b.price));
    if (sortMode == 'الأعلى سعراً') list.sort((a, b) => b.price.compareTo(a.price));
    return list;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, textDirection: TextDirection.rtl)),
    );
  }

  Future<void> addProduct() async {
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController();
    final price = TextEditingController();
    final shop = TextEditingController();
    String category = 'زيوت';
    String city = 'الخرطوم';

    final result = await showDialog<Product>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('إضافة منتج تجريبي', textDirection: TextDirection.rtl),
          content: SizedBox(
            width: 420,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: shop,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(labelText: 'اسم المتجر'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'اكتب اسم المتجر' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: name,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(labelText: 'اسم المنتج'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'اكتب اسم المنتج' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: price,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'السعر بالجنيه السوداني'),
                      validator: (v) {
                        if (v == null || int.tryParse(v.trim()) == null || int.parse(v.trim()) <= 0) {
                          return 'أدخل سعراً صحيحاً';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: const InputDecoration(labelText: 'القسم'),
                      items: categories.where((c) => c.$1 != 'الكل').map((c) =>
                        DropdownMenuItem(value: c.$1, child: Text(c.$1))).toList(),
                      onChanged: (v) => setDialogState(() => category = v ?? 'زيوت'),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: city,
                      decoration: const InputDecoration(labelText: 'المدينة'),
                      items: ['الخرطوم', 'أم درمان', 'بحري', 'بورتسودان'].map((c) =>
                        DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) => setDialogState(() => city = v ?? 'الخرطوم'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                const emojis = {'زيوت': '🛢️', 'قطع غيار': '⚙️', 'بطاريات': '🔋', 'إطارات': '🛞', 'كهرباء': '🔌'};
                Navigator.pop(dialogContext, Product(
                  name: name.text.trim(),
                  category: category,
                  price: int.parse(price.text.trim()),
                  city: city,
                  shop: shop.text.trim(),
                  emoji: emojis[category] ?? '📦',
                  description: 'أضيف في النموذج التجريبي',
                ));
              },
              child: const Text('إضافة'),
            ),
          ],
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        products.insert(0, result);
        selectedCategory = 'الكل';
        selectedCity = 'كل المدن';
        searchController.clear();
      });
      showMessage('تمت إضافة المنتج لهذه الجلسة التجريبية فقط.');
    }
  }

  void showProduct(Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
          child: Wrap(
            runSpacing: 12,
            children: [
              Center(child: Text(product.emoji, style: const TextStyle(fontSize: 58))),
              Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(product.description, style: const TextStyle(color: Colors.black54)),
              Text(money(product.price), style: const TextStyle(fontSize: 22, color: brand, fontWeight: FontWeight.w900)),
              ListTile(leading: const Icon(Icons.storefront_outlined), title: Text(product.shop), subtitle: Text(product.city)),
              ListTile(
                leading: Icon(product.available ? Icons.check_circle_outline : Icons.cancel_outlined,
                    color: product.available ? brand : Colors.red),
                title: Text(product.available ? 'التوفر معلن من المتجر' : 'غير متوفر حالياً'),
              ),
              const Text('تحقق من السعر والتوفر وتوافق القطعة مع سيارتك قبل الشراء.',
                  style: TextStyle(fontSize: 12, color: Colors.black54)),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    showMessage('التواصل المباشر سيُضاف عند ربط التطبيق بخدمة خلفية.');
                  },
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('تواصل مع المتجر'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = filteredProducts;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: brand, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.manage_search, color: Colors.white, size: 27),
            ),
            const SizedBox(width: 10),
            const Text('اسبيرك | Espairak', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 23)),
          ]),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: FilledButton.icon(
                onPressed: addProduct,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('أضف منتج'),
              ),
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _hero()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 8),
                child: Row(
                  children: [
                    const Expanded(child: Text('تصفح حسب القسم', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                    Text('${products.length} منتجات', style: const TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: _categories()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('المنتجات المتاحة', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    const Text('قارن السعر والمدينة واسم المتجر', style: TextStyle(color: Colors.black54, fontSize: 13)),
                    const SizedBox(height: 13),
                    Row(children: [
                      Expanded(child: DropdownButtonFormField<String>(
                        value: selectedCity,
                        isExpanded: true,
                        decoration: const InputDecoration(prefixIcon: Icon(Icons.location_on_outlined), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                        items: ['كل المدن', 'الخرطوم', 'أم درمان', 'بحري', 'بورتسودان'].map((c) =>
                          DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (v) => setState(() => selectedCity = v ?? 'كل المدن'),
                      )),
                      const SizedBox(width: 9),
                      Expanded(child: DropdownButtonFormField<String>(
                        value: sortMode,
                        isExpanded: true,
                        decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                        items: ['المقترحة', 'الأقل سعراً', 'الأعلى سعراً'].map((c) =>
                          DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (v) => setState(() => sortMode = v ?? 'المقترحة'),
                      )),
                    ]),
                  ],
                ),
              ),
            ),
            if (results.isEmpty)
              const SliverToBoxAdapter(child: Padding(
                padding: EdgeInsets.all(30),
                child: Center(child: Text('لا توجد منتجات مطابقة. جرّب بحثاً آخر.')),
              ))
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 310,
                    mainAxisExtent: 292,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductCard(product: results[index], onTap: () => showProduct(results[index])),
                    childCount: results.length,
                  ),
                ),
              ),
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 26),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFE7F5F2), borderRadius: BorderRadius.circular(18)),
                child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('مهم قبل الشراء', style: TextStyle(fontWeight: FontWeight.bold, color: brandDark)),
                  SizedBox(height: 6),
                  Text('هذه نسخة تجريبية ببيانات توضيحية. الأسعار ليست عروضاً مؤكدة، وإضافة المنتجات لا تنشرها لمستخدمين آخرين بعد.'),
                ]),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _hero() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [brandDark, brand]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.white.withOpacity(.15), borderRadius: BorderRadius.circular(20)),
            child: const Text('سوق زيوت وقطع غيار السيارات', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
          const SizedBox(height: 15),
          const Text('السلعة البتفتش عنها؟\nحتلقاها في اسبيرك | Espairak.', style: TextStyle(color: Colors.white, fontSize: 27, height: 1.35, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('ابحث، قارن الأسعار، واعرف المتاجر التي تعرض السلعة التي تحتاجها.', style: TextStyle(color: Color(0xFFD9F1ED), height: 1.7)),
          const SizedBox(height: 16),
          TextField(
            controller: searchController,
            textInputAction: TextInputAction.search,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'ابحث عن زيت، فلتر، بطارية...',
              hintStyle: const TextStyle(fontSize: 13),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () => setState(() => searchController.clear()),
                icon: const Icon(Icons.close),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _categories() {
    return SizedBox(
      height: 105,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final c = categories[index];
          final selected = selectedCategory == c.$1;
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(() => selectedCategory = c.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 94,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFE7F5F2) : Colors.white,
                border: Border.all(color: selected ? brand : const Color(0xFFE5ECEA)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(c.$2, style: const TextStyle(fontSize: 25)),
                const SizedBox(height: 7),
                Text(c.$1 == 'الكل' ? 'كل المنتجات' : c.$1,
                    textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});
  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE5ECEA)), borderRadius: BorderRadius.circular(18)),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 86,
            width: double.infinity,
            color: const Color(0xFFEDF4F2),
            child: Stack(children: [
              Center(child: Text(product.emoji, style: const TextStyle(fontSize: 46))),
              Positioned(
                top: 8, right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(7)),
                  child: Text(product.available ? 'متوفر' : 'غير متوفر', style: const TextStyle(fontSize: 10, color: brand, fontWeight: FontWeight.bold)),
                ),
              ),
            ]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(11),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 5),
                Text(product.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black54, fontSize: 11)),
                const SizedBox(height: 7),
                FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerRight,
                  child: Text(money(product.price), style: const TextStyle(color: brand, fontWeight: FontWeight.w900, fontSize: 16))),
                const Spacer(),
                Row(children: [
                  const Icon(Icons.storefront_outlined, size: 15, color: Colors.black45),
                  const SizedBox(width: 5),
                  Expanded(child: Text('${product.shop} · ${product.city}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.black54))),
                  if (product.verified) const Icon(Icons.verified, size: 15, color: brand),
                ]),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onTap,
                    style: FilledButton.styleFrom(minimumSize: const Size(0, 36), padding: const EdgeInsets.symmetric(horizontal: 8)),
                    child: const Text('عرض التفاصيل', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
