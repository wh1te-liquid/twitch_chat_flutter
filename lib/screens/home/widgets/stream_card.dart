// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';

// Project imports:
import 'package:twitch_chat_flutter/models/stream.dart';
import 'package:twitch_chat_flutter/screens/home/widgets/profile_picture.dart';
import 'package:twitch_chat_flutter/widgets/animate_scale.dart';

class StreamCard extends StatelessWidget {
  final StreamTwitch streamInfo;

  const StreamCard({Key? key, required this.streamInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateScale(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return CachedNetworkImage(
                      imageUrl: streamInfo.thumbnailUrl.replaceFirst(
                          '-{width}x{height}',
                          '-${constraints.minWidth.toInt()}x${constraints.minHeight.toInt()}'),
                      useOldImageOnUrlChange: true,
                      placeholder: (ctx, _) => const Center(
                          child: CircularProgressIndicator.adaptive()),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ProfilePicture(
                          userLogin: streamInfo.userLogin,
                          radius: 10,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          streamInfo.userName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Text(
                      streamInfo.title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      streamInfo.gameName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
