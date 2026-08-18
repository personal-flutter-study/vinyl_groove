import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_10/main.dart';
import 'package:vinyl_groove_poc_10/models/album_model.dart';
import 'package:vinyl_groove_poc_10/screens/album_screen.dart';
import 'package:vinyl_groove_poc_10/widgets/like_button.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({super.key, required this.album, this.size = 13});

  final AlbumModel album;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: black3,
      clipBehavior: .antiAlias,
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
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
                            color: Colors.black87,
                            borderRadius: .circular(4),
                          ),
                          padding: .symmetric(horizontal: 8, vertical: 4),
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
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 4,
                  children: [
                    Text(
                      album.albumName,
                      overflow: .ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: .w500,
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
                        fontWeight: .w500,
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
