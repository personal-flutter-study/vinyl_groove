import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_2/models/album_model.dart';
import 'package:vinyl_groove_poc_2/screens/album_screen.dart';
import 'package:vinyl_groove_poc_2/widgets/like_button.dart';

import '../main.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({super.key, required this.album});

  final AlbumModel album;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(AlbumScreen(id: album.id));
      },
      child: Container(
        width: 140,
        height: 180,
        clipBehavior: .antiAlias,
        decoration: BoxDecoration(color: black3, borderRadius: .circular(12)),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 4,
          children: [
            SizedBox(
              height: 100,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(album.albumImage, fit: .cover),
                  ),

                  Align(
                    alignment: .topRight,
                    child: LikeButton(albumModel: album),
                  ),

                  Align(
                    alignment: .bottomLeft,
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: .circular(2)),
                      color: Colors.black54,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          album.condition,
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: .start,
                spacing: 4,
                children: [
                  Text(
                    maxLines: 1,
                    album.albumName,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    maxLines: 1,
                    album.artist,
                    style: TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                  Text(
                    maxLines: 1,
                    "\₩ ${NumberFormat('#,###').format(album.price)}",
                    style: TextStyle(color: yellow, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
