import 'package:template_vgv_app/core/common/paginated_result.dart';

mixin PagedResponseMapper<T> {
  int get page;
  int get totalPages;
  List<T> get data;

  PaginatedResult<E> toPaginatedResult<E>(E Function(T) mapper) =>
      PaginatedResult(
        items: data.map(mapper).toList(),
        currentPage: page,
        totalPages: totalPages,
      );
}
