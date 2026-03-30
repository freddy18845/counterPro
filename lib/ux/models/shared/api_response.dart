// ── API Response wrapper ──────────────────────────────────────
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? statusCode;

  ApiResponse({required this.success, this.data, this.error, this.statusCode});

  factory ApiResponse.success(T data, {int? statusCode}) =>
      ApiResponse(success: true, data: data, statusCode: statusCode);

  factory ApiResponse.error(String message, {int? statusCode}) =>
      ApiResponse(success: false, error: message, statusCode: statusCode);
}
