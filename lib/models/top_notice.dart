class TopNotice {
  final String id;
  final String notice;
  final DateTime timestamp;

  TopNotice({
    required this.id,
    required this.notice,
    required this.timestamp,
  });

  factory TopNotice.fromJson(Map<String, dynamic> json) {
    return TopNotice(
      id: json['id'],
      notice: json['notice'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
