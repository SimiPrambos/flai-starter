class SingleResponse<T> {
  const SingleResponse({required this.data});

  factory SingleResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) => SingleResponse(data: fromJsonT(json['data'] as Map<String, dynamic>));
  final T data;
}
