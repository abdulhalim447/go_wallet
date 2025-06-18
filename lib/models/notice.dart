class Notice {
  final int id;
  final String title;
  final String notice;
  final String timestamp;

  Notice({
    required this.id,
    required this.title,
    required this.notice,
    required this.timestamp,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: int.parse(json['id'].toString()),
      title: json['title'] as String,
      notice: json['notice'] as String,
      timestamp: json['timestamp'] as String,
    );
  }
}
