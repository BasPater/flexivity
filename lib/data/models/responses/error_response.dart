class ErrorResponse {
  final String message;
  final String status;
  final DateTime timestamp;

  const ErrorResponse(this.message, this.status, this.timestamp);

  ErrorResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        status = json['status'],
        timestamp = DateTime.fromMillisecondsSinceEpoch(json['timestamp']);

  Map<String, dynamic> toJson() => {
        'message': this.message,
        'status': this.status,
        'timestamp': this.timestamp.millisecondsSinceEpoch,
      };
}
