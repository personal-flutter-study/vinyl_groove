import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_14/app_ctrl.dart';
import 'package:vinyl_groove_poc_14/models/album_model.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({super.key, required this.albumModel, this.size = 18});

  final AlbumModel albumModel;
  final double size;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool press = false;

  @override
  Widget build(BuildContext context) {
    final album = widget.albumModel;
    return AnimatedScale(
      duration: Duration(milliseconds: 300),
      scale: press ? 1.4 : 1,
      curve: Curves.easeInOutCubic,
      child: ValueListenableBuilder(
        valueListenable: appCtrl.ticker,
        builder: (context, _, child) {
          final fav = appCtrl.likes.contains(album);
          return IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.black54,
              minimumSize: .zero,
            ),
            onPressed: () async {
              press = true;
              setState(() {});
              await Future.delayed(Duration(milliseconds: 150));
              press = false;
              setState(() {});
              if (!appCtrl.likes.remove(album)) appCtrl.likes.add(album);
              appCtrl.save();
            },
            icon: Icon(
              size: widget.size,
              fav ? Icons.favorite : Icons.favorite_outline,
              color: fav ? Colors.red : Colors.white,
            ),
          );
        },
      ),
    );
  }
}
