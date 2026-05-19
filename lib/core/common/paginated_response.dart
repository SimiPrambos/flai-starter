import 'package:template_vgv_app/core/common/paged_response_mapper.dart';

class PaginatedResponse<T> with PagedResponseMapper<T> {
  const PaginatedResponse({
    required this.page,
    required this.totalPages,
    required this.data,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) => PaginatedResponse(
    page: json['page'] as int,
    totalPages: json['total_pages'] as int,
    data: (json['data'] as List<dynamic>)
        .map((e) => fromJsonT(e as Map<String, dynamic>))
        .toList(),
  );

  @override
  final int page;
  @override
  final int totalPages;
  @override
  final List<T> data;
}
