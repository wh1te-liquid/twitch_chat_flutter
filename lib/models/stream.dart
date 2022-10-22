class StreamTwitch {
  final String userId;
  final String userLogin;
  final String userName;
  final String gameId;
  final String gameName;
  final String title;
  final int viewerCount;
  final String startedAt;
  final String thumbnailUrl;

  const StreamTwitch({
    required this.userId,
    required this.userLogin,
    required this.userName,
    required this.gameId,
    required this.gameName,
    required this.title,
    required this.viewerCount,
    required this.startedAt,
    required this.thumbnailUrl,
  });

  factory StreamTwitch.fromJson(Map<String, dynamic> json) {
    return StreamTwitch(
      userId: json['user_id'],
      userLogin: json['user_login'],
      userName: json['user_name'],
      gameId: json['game_id'],
      gameName: json['game_name'],
      title: json['title'],
      viewerCount: json['viewer_count'],
      startedAt: json['started_at'],
      thumbnailUrl: json['thumbnail_url'],
    );
  }
}
