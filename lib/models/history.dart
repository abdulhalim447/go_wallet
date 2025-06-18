class History {
  final int id;
  final int userId;
  final String history;
  final DateTime timestamp;

  History({
    required this.id,
    required this.userId,
    required this.history,
    required this.timestamp,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      userId: json['user_id'],
      history: json['history'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
