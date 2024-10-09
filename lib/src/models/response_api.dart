class ResponseApi {
  String? message;
  String? error;
  bool? success;
  dynamic data;

  ResponseApi({
    this.message,
    this.error,
    this.success,
    this.data,
  });

  factory ResponseApi.fromJson(Map<String, dynamic> json) => ResponseApi(
    message: json["message"] as String?,
    error: json["error"] as String?,
    success: json["success"] as bool?,
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "error": error,
    "success": success,
    "data": data,
  };
}
