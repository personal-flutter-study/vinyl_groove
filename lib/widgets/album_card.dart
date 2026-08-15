import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_4/main.dart';
import 'package:vinyl_groove_poc_4/models/album_model.dart';
import 'package:vinyl_groove_poc_4/screens/album_screen.dart';
import 'package:vinyl_groove_poc_4/widgets/like_button.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({super.key, required this.album, this.small = false});

  final AlbumModel album;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: .antiAlias,
      color: black3,
      child: InkWell(
        onTap: () {
          context.go(AlbumScreen(id: album.id));
        },
        child: SizedBox(
          width: 140,
          height: 220,
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
                          padding: .symmetric(vertical: 2, horizontal: 6),
                          child: Text(
                            album.condition,
                            style: TextStyle(
                              fontWeight: .w500,
                              color: Colors.white,
                              fontSize: 12,
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
                      overflow: .ellipsis,
                      album.albumName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: .w500,
                        fontSize: small ? 10 : 14,
                      ),
                    ),
                    Text(
                      overflow: .ellipsis,
                      album.artist,
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: small ? 10 : 14,
                      ),
                    ),
                    Text(
                      overflow: .ellipsis,
                      NumberFormat('₩ #,###').format(album.price),
                      style: TextStyle(
                        color: yellow,
                        fontWeight: .w500,
                        fontSize: small ? 10 : 14,
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
