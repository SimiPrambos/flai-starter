class PaginatedResult<T> {
  const PaginatedResult({
    required this.items,
    required this.currentPage,
    required this.totalPages,
  });

  final List<T> items;
  final int currentPage;
  final int totalPages;

  bool get hasMore => currentPage < totalPages;
}
