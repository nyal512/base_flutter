import '../../../../core/viewmodel/base_view_model.dart';

class CategoryItem {
  final int no;
  final String image;
  final String category;
  final String buttonType;
  final bool status;
  final String? imageUrl; // Default/Legacy
  final String? imageUrlJp;
  final String? imageUrlEn;
  final String? imageUrlCn;
  final String? imageUrlKr;
  final String fontSize;
  final String backgroundColor;
  final String fontColor;
  final int widthSpan;
  final int heightSpan;
  final String targetScreen;

  CategoryItem({
    required this.no,
    required this.image,
    required this.category,
    required this.buttonType,
    required this.status,
    this.imageUrl,
    this.imageUrlJp,
    this.imageUrlEn,
    this.imageUrlCn,
    this.imageUrlKr,
    this.fontSize = '18px',
    this.backgroundColor = '#FFFFFF',
    this.fontColor = '#000000',
    this.widthSpan = 1,
    this.heightSpan = 1,
    this.targetScreen = '商品選択画面',
  });

  CategoryItem copyWith({
    int? no,
    String? image,
    String? category,
    String? buttonType,
    bool? status,
    String? imageUrl,
    String? imageUrlJp,
    String? imageUrlEn,
    String? imageUrlCn,
    String? imageUrlKr,
    String? fontSize,
    String? backgroundColor,
    String? fontColor,
    int? widthSpan,
    int? heightSpan,
    String? targetScreen,
  }) {
    return CategoryItem(
      no: no ?? this.no,
      image: image ?? this.image,
      category: category ?? this.category,
      buttonType: buttonType ?? this.buttonType,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrlJp: imageUrlJp ?? this.imageUrlJp,
      imageUrlEn: imageUrlEn ?? this.imageUrlEn,
      imageUrlCn: imageUrlCn ?? this.imageUrlCn,
      imageUrlKr: imageUrlKr ?? this.imageUrlKr,
      fontSize: fontSize ?? this.fontSize,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontColor: fontColor ?? this.fontColor,
      widthSpan: widthSpan ?? this.widthSpan,
      heightSpan: heightSpan ?? this.heightSpan,
      targetScreen: targetScreen ?? this.targetScreen,
    );
  }
}

class ProductItem {
  final int id;
  final String name;
  final String? imageUrl;
  final int categoryNo;
  final String? buttonType;
  final String? price;
  final String? backgroundColor;
  final String? fontColor;
  final String? fontSize;

  ProductItem({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.categoryNo,
    this.buttonType,
    this.price,
    this.backgroundColor,
    this.fontColor,
    this.fontSize,
  });

  ProductItem copyWith({
    int? id,
    String? name,
    String? imageUrl,
    int? categoryNo,
    String? buttonType,
    String? price,
    String? backgroundColor,
    String? fontColor,
    String? fontSize,
  }) {
    return ProductItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryNo: categoryNo ?? this.categoryNo,
      buttonType: buttonType ?? this.buttonType,
      price: price ?? this.price,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontColor: fontColor ?? this.fontColor,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}

class ProductAreaViewModel extends BaseViewModel {
  final String _currentFileName = 'master_ticket_layout.dat';
  String get currentFileName => _currentFileName;

  String _verticalBgColor = '#F2F1ED';
  String get verticalBgColor => _verticalBgColor;

  String _horizontalBgColor = '#F2F1ED';
  String get horizontalBgColor => _horizontalBgColor;

  void updateVerticalBgColor(String color) {
    _verticalBgColor = color;
    notifyListeners();
  }

  void updateHorizontalBgColor(String color) {
    _horizontalBgColor = color;
    notifyListeners();
  }

  final List<CategoryItem> _categories = [
    CategoryItem(
      no: 1,
      image: '🍱',
      category: 'おにぎり',
      buttonType: 'カテゴリボタン大',
      status: true,
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=200&auto=format&fit=crop',
      imageUrlJp: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=200&auto=format&fit=crop',
      backgroundColor: '#FEF2F2',
      fontColor: '#991B1B',
      widthSpan: 1,
      heightSpan: 1,
      targetScreen: '商品選択画面',
    ),
    CategoryItem(
      no: 2,
      image: '🍛',
      category: '定食',
      buttonType: 'カテゴリボタン特大',
      status: true,
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=200&auto=format&fit=crop',
      imageUrlJp: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=200&auto=format&fit=crop',
      backgroundColor: '#EFF6FF',
      fontColor: '#1E40AF',
      widthSpan: 2,
      heightSpan: 2,
      targetScreen: '商品選択画面',
    ),
    CategoryItem(
      no: 3,
      image: '🍜',
      category: '冷凍食品',
      buttonType: 'カテゴリボタン横(長)',
      status: true,
      imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?q=80&w=200&auto=format&fit=crop',
      imageUrlJp: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?q=80&w=200&auto=format&fit=crop',
      backgroundColor: '#F0FDF4',
      fontColor: '#166534',
      widthSpan: 2,
      heightSpan: 1,
      targetScreen: '商品選択画面',
    ),
  ];

  final List<ProductItem> _products = [
    ProductItem(id: 1, name: 'おにぎり', imageUrl: 'https://i.pinimg.com/736x/d9/db/94/d9db947145fb931a2bd2b0dc46b59ac0.jpg', categoryNo: 1),
    ProductItem(id: 2, name: '定食', imageUrl: 'https://images.unsplash.com/photo-1534422298391-e4f8c170db96?q=80&w=400&fit=crop', categoryNo: 2),
  ];

  int _selectedCategoryNo = 1;
  int get selectedCategoryNo => _selectedCategoryNo;

  void selectCategory(int no) {
    _selectedCategoryNo = no;
    notifyListeners();
  }

  List<CategoryItem> get categories => _categories;
  List<ProductItem> get products => _products.where((p) => p.categoryNo == _selectedCategoryNo).toList();

  void updateActiveCategoriesOrder(List<CategoryItem> reorderedActive) {
    final inactive = _categories.where((c) => !c.status).toList();
    _categories.clear();
    _categories.addAll(reorderedActive);
    _categories.addAll(inactive);
    notifyListeners();
  }

  void reorderCategories(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final CategoryItem item = _categories.removeAt(oldIndex);
    _categories.insert(newIndex, item);
    notifyListeners();
  }

  void addCategory(CategoryItem item) {
    _categories.add(item);
    notifyListeners();
  }

  void updateCategory(CategoryItem updatedItem) {
    final index = _categories.indexWhere((item) => item.no == updatedItem.no);
    if (index != -1) {
      _categories[index] = updatedItem;
      notifyListeners();
    }
  }

  void toggleStatus(int no) {
    final index = _categories.indexWhere((item) => item.no == no);
    if (index != -1) {
      _categories[index] = _categories[index].copyWith(status: !_categories[index].status);
      notifyListeners();
    }
  }

  void onDeleteCategory(int no) {
    _categories.removeWhere((item) => item.no == no);
    notifyListeners();
  }

  void addProduct(ProductItem product) {
    _products.add(product);
    notifyListeners();
  }

  void deleteProduct(int id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void updateTabSettings(Map<String, dynamic> settings) {
    // In a real app, this might update a specific category or global config
    // For now, we'll just notify to refresh the UI
    notifyListeners();
  }

  void onImportFile() {
    // Implement file import logic
    notifyListeners();
  }

  void onSave() {
    // Implement save logic
    notifyListeners();
  }

  void onAddToFavorites() {
    // Implement add to favorites logic
    notifyListeners();
  }
}
