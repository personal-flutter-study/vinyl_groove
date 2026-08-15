import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_7/main.dart';
import 'package:vinyl_groove_poc_7/models/album_model.dart';
import 'package:vinyl_groove_poc_7/screens/album_screen.dart';
import 'package:vinyl_groove_poc_7/widgets/like_button.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({super.key, required this.album, this.size = 12});

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
          height: 210,
          width: 140,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              SizedBox(
                height: 130,
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
                            color: Colors.black54,
                            borderRadius: .circular(4),
                          ),
                          padding: .symmetric(horizontal: 6, vertical: 2),
                          child: Text(
                            album.condition,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: .bold,
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
                        fontWeight: .bold,
                        fontSize: size,
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
                        fontWeight: .bold,
                        fontSize: size,
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
