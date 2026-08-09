import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_1/main.dart';
import 'package:vinyl_groove_poc_1/models/album_model.dart';

import '../app_ctrl.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({super.key, required this.albumModel, this.action});

  final AlbumModel albumModel;

  final VoidCallback? action;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool press = false;

  @override
  Widget build(BuildContext context) {
    final album = widget.albumModel;
    return ValueListenableBuilder(
      valueListenable: appCtrl.ticker,
      builder: (context, value, child) {
        return AnimatedScale(
          duration: Duration(milliseconds: 100),
          scale: press ? 1.2 : 1.0,
          child: IconButton(
            style: IconButton.styleFrom(backgroundColor: Colors.black54),
            onPressed: () async {
              press = true;
              setState(() {});

              widget.action?.call();
              if (widget.action == null && !appCtrl.likes.remove(album)) {
                appCtrl.likes.add(album);
              }
              await Future.delayed(Duration(milliseconds: 200));

              await prefs.setStringList(
                lsk,
                appCtrl.likes.map((e) => jsonEncode(e.toJson())).toList(),
              );

              press = false;
              setState(() {});

              appCtrl.ticker.value++;
            },
            icon: Icon(
              appCtrl.likes.contains(album)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: appCtrl.likes.contains(album) ? Colors.red : Colors.white,
            ),
          ),
        );
      },
    );
  }
}
