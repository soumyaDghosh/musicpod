import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/data/audio.dart';
import '../../common/view/icons.dart';
import '../../common/view/theme.dart';
import '../../extensions/build_context_x.dart';
import '../../player/player_model.dart';
import 'audio_progress.dart';

class AvatarWithProgress extends StatelessWidget {
  const AvatarWithProgress({
    super.key,
    required this.selected,
    required this.audio,
    required this.isPlayerPlaying,
    required this.startPlaylist,
    required this.removeUpdate,
  });

  final bool selected;
  final Audio audio;
  final bool isPlayerPlaying;

  final void Function()? startPlaylist;
  final void Function()? removeUpdate;

  @override
  Widget build(BuildContext context) {
    final playerModel = di<PlayerModel>();
    final theme = context.t;
    return Stack(
      alignment: Alignment.center,
      children: [
        AudioProgress(
          selected: selected,
          lastPosition: playerModel.getLastPosition(audio.url),
          duration: audio.durationMs == null
              ? null
              : Duration(milliseconds: audio.durationMs!.toInt()),
        ),
        CircleAvatar(
          radius: avatarIconSize,
          backgroundColor: selected
              ? theme.colorScheme.primary.withOpacity(0.08)
              : theme.colorScheme.onSurface.withOpacity(0.09),
          child: IconButton(
            icon: (isPlayerPlaying && selected)
                ? Icon(
                    Iconz().pause,
                  )
                : Padding(
                    padding: appleStyled
                        ? const EdgeInsets.only(left: 3)
                        : EdgeInsets.zero,
                    child: Icon(Iconz().playFilled),
                  ),
            onPressed: () {
              if (selected) {
                if (isPlayerPlaying) {
                  playerModel.pause();
                } else {
                  playerModel.resume();
                }
              } else {
                playerModel.safeLastPosition().then((value) {
                  startPlaylist?.call();
                  removeUpdate?.call();
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
