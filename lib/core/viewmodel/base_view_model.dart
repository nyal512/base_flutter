import 'package:flutter/foundation.dart';

/// Base class for all ViewModels in the MVVM pattern.
/// Uses [ChangeNotifier] to automatically rebuild the View when the state changes.
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Updates the loading state and notifies listeners.
  @protected
  void setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  /// Sets an error message and notifies listeners.
  @protected
  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Clears the current error.
  @protected
  void clearError() => setError(null);

  /// Called when the Widget is initialized (initState).
  @mustCallSuper
  void init() {}

  /// Called when the Widget is disposed.
  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
  }
}
