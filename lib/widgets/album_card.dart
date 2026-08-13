import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_5/main.dart';
import 'package:vinyl_groove_poc_5/models/album_model.dart';
import 'package:vinyl_groove_poc_5/screens/album_screen.dart';
import 'package:vinyl_groove_poc_5/widgets/like_button.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({super.key, required this.album, this.small = false});

  final AlbumModel album;

  final bool small;

  @override
  Widget build(BuildContext context) {
    final double size = small ? 10 : 12;
    return InkWell(
      onTap: () {
        context.go(AlbumScreen(id: album.id));
      },
      child: Material(
        color: black3,
        clipBehavior: .antiAlias,
        borderRadius: .circular(12),
        child: SizedBox(
          height: 200,
          width: 140,
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
                            color: Colors.black54,
                            borderRadius: .circular(4),
                          ),
                          padding: .symmetric(vertical: 4, horizontal: 6),
                          child: Text(
                            album.condition,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size,
                              fontWeight: .bold,
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
                      overflow: .ellipsis,
                      album.albumName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: .w500,
                        fontSize: size,
                      ),
                    ),
                    Text(
                      overflow: .ellipsis,
                      album.artist,
                      style: TextStyle(color: Colors.white60, fontSize: 11),
                    ),
                    Text(
                      overflow: .ellipsis,
                      NumberFormat('₩ #,###').format(album.price),
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
