import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_2/app_ctrl.dart';
import 'package:vinyl_groove_poc_2/models/album_model.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.albumModel,
    this.size = 18,
    this.fav,
    this.act,
  });

  final AlbumModel albumModel;

  final double size;
  final bool? fav;
  final VoidCallback? act;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool press = false;

  @override
  Widget build(BuildContext context) {
    final album = widget.albumModel;

    return ListenableBuilder(
      listenable: appCtrl.ticker,
      builder: (context, child) {
        final fav = widget.fav ?? appCtrl.likes.contains(album);
        return AnimatedScale(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
          scale: press ? 1.2 : 1,
          child: IconButton(
            style: IconButton.styleFrom(
              minimumSize: .zero,
              backgroundColor: Colors.black54,
              foregroundColor: fav ? Colors.red : Colors.white,
            ),
            onPressed: () async {
              press = true;
              setState(() {});
              await Future.delayed(Duration(milliseconds: 200));
              press = false;
              setState(() {});

              if (widget.act != null) {
                widget.act?.call();
              } else {
                if (!appCtrl.likes.remove(album)) {
                  appCtrl.likes.add(album);
                }
                await appCtrl.save();
              }
              setState(() {});
              appCtrl.ticker.value++;
            },
            icon: Icon(
              fav ? Icons.favorite : Icons.favorite_border,
              size: widget.size,
            ),
          ),
        );
      },
    );
  }
}
