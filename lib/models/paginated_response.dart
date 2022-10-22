class PaginatedResponse<T> {
  final List<T> _items;
  final String _next;

  PaginatedResponse({required List<T> items, required String next})
      : _items = items,
        _next = next;

  List<T> get items => _items;

  String get next => _next;
}
