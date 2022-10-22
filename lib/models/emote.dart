class Emote {
  final String name;
  final int? width;
  final int? height;
  final bool zeroWidth;
  final String url;
  final EmoteType type;
  final String? ownerId;

  const Emote({
    required this.name,
    this.width,
    this.height,
    required this.zeroWidth,
    required this.url,
    required this.type,
    this.ownerId,
  });
}

enum EmoteType {
  twitchBits,
  twitchFollower,
  twitchSub,
  twitchGlobal,
  twitchUnlocked,
  twitchChannel,
  ffzGlobal,
  ffzChannel,
  bttvGlobal,
  bttvChannel,
  bttvShared,
  sevenTVGlobal,
  sevenTVChannel,
}
