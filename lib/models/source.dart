class Source {
  final String? nick;
  final String host;

  Source({required this.nick, required this.host});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      nick: json['nick'],
      host: json['host'],
    );
  }
}
