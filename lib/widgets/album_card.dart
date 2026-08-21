import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_14/main.dart';
import 'package:vinyl_groove_poc_14/models/album_model.dart';
import 'package:vinyl_groove_poc_14/screens/album_screen.dart';
import 'package:vinyl_groove_poc_14/widgets/like_button.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({super.key, required this.album, this.size = 13});

  final AlbumModel album;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: .antiAlias,
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      color: black3,
      child: InkWell(
        onTap: () {
          context.go(AlbumScreen(id: album.id));
        },
        child: SizedBox(
          width: 140,
          height: 210,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              SizedBox(
                height: 120,
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: .circular(6),
                            color: Colors.black.withAlpha(180),
                          ),
                          padding: .symmetric(horizontal: 6, vertical: 4),
                          child: Text(
                            album.condition,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: .w500,
                              fontSize: 10,
                            ),
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
                      album.albumName,
                      overflow: .ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size,
                        fontWeight: .w500,
                      ),
                    ),
                    Text(
                      album.artist,
                      overflow: .ellipsis,
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: size - 1,
                      ),
                    ),
                    Text(
                      NumberFormat('₩ #,###').format(album.price),
                      overflow: .ellipsis,
                      style: TextStyle(
                        color: yellow,
                        fontSize: size,
                        fontWeight: .w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
