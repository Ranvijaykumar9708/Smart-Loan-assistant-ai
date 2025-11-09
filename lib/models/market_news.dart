/// Market news model
class MarketNews {
  final String id;
  final String title;
  final String category;
  final String sentiment; // 'Positive', 'Neutral', 'Negative'
  final DateTime timestamp;
  final String? aiComment;

  MarketNews({
    required this.id,
    required this.title,
    required this.category,
    required this.sentiment,
    required this.timestamp,
    this.aiComment,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'sentiment': sentiment,
        'timestamp': timestamp.toIso8601String(),
        'aiComment': aiComment,
      };

  factory MarketNews.fromJson(Map<String, dynamic> json) => MarketNews(
        id: json['id'] as String,
        title: json['title'] as String,
        category: json['category'] as String,
        sentiment: json['sentiment'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        aiComment: json['aiComment'] as String?,
      );
}

