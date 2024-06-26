import 'package:flutter/material.dart';

import '../../../common.dart';
import '../../../constants.dart';
import '../../../data.dart';
import '../../../get.dart';
import '../local_audio_model.dart';
import 'album_page.dart';
import 'artist_page.dart';

class TitlesView extends StatelessWidget {
  const TitlesView({
    super.key,
    required this.audios,
    this.noResultMessage,
    this.noResultIcon,
    required this.classicTiles,
  });

  final Set<Audio>? audios;
  final Widget? noResultMessage, noResultIcon;
  final bool classicTiles;

  @override
  Widget build(BuildContext context) {
    final model = getIt<LocalAudioModel>();

    return AudioPageBody(
      classicTiles: classicTiles,
      showAlbum: classicTiles,
      padding: const EdgeInsets.only(top: 10),
      showTrack: false,
      noResultIcon: noResultIcon,
      noResultMessage: noResultMessage,
      audios: audios,
      audioPageType: AudioPageType.allTitlesView,
      pageId: kLocalAudioPageId,
      onAlbumTap: (text) {
        final albumAudios = model.findAlbum(Audio(album: text));
        if (albumAudios?.firstOrNull == null) return;
        final id = albumAudios!.first.albumId;
        if (id == null) return;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return AlbumPage(
                id: id,
                album: albumAudios,
              );
            },
          ),
        );
      },
      onArtistTap: (text) {
        final artistAudios = model.findArtist(Audio(artist: text));
        final images = model.findImages(artistAudios ?? {});

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return ArtistPage(
                images: images,
                artistAudios: artistAudios,
              );
            },
          ),
        );
      },
    );
  }
}
