import 'package:flutter/material.dart';

get qw1 => SafeArea(
  child: Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: Colors.black,
    body: Column(children: []),
  ),
);

get qw2 => TextField(
  controller: em,
  style: TextStyle(color: Colors.white),
  decoration: InputDecoration(
    fillColor: .lerp(Colors.black, Colors.white, .05),
    filled: true,
    border: OutlineInputBorder(borderRadius: .circular(12)),
    prefixIcon: Icon(Icons.email_outlined, color: Colors.white60),
    hintStyle: TextStyle(color: Colors.white60),
    hintText: '이메일을 입력해주세요.',
  ),
);

get qw3 => ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: yellow,
    shape: RoundedRectangleBorder(borderRadius: .circular(12)),
    padding: .symmetric(vertical: 16),
  ),
  onPressed: () async {},
  child: Row(
    mainAxisAlignment: .center,
    children: [
      Text(
        '로그인',
        style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: .bold),
      ),
    ],
  ),
);

get qw4 => GestureDetector(
  onTap: () {
    context.go(AlbumScreen(albumModel: e));
  },
  child: Container(
    width: 160,
    height: 240,
    clipBehavior: .antiAlias,
    decoration: BoxDecoration(
      borderRadius: .circular(12),
      color: .lerp(Colors.black, Colors.white, .2),
    ),
    child: Column(
      crossAxisAlignment: .start,
      spacing: 4,
      children: [
        SizedBox(
          height: 140,
          child: Stack(
            children: [
              Positioned.fill(child: Image.network(e.albumImage, fit: .cover)),

              Align(
                alignment: .bottomLeft,
                child: Card(
                  margin: .all(8),
                  shape: RoundedRectangleBorder(borderRadius: .circular(4)),
                  color: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      e.condition,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 4,
            crossAxisAlignment: .start,
            children: [
              Text(
                overflow: .ellipsis,
                e.albumName,
                style: TextStyle(color: Colors.white, fontWeight: .bold),
              ),
              Text(
                e.artist,
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),

              Text(
                '₩ ${NumberFormat('###,###').format(e.price)}',
                style: TextStyle(
                  color: yellow,
                  fontWeight: .bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);

get qs1 => TextButton(
  onPressed: () {
    context.go(SignupScreen());
  },
  child: Text(
    '회원가입',
    style: TextStyle(fontWeight: .bold, fontSize: 14, color: yellow),
  ),
);

get qs2 => TextButton(
  style: TextButton.styleFrom(foregroundColor: Colors.white60),
  onPressed: () {},
  child: Row(
    spacing: 4,
    mainAxisSize: .min,
    children: [
      Text('전체 보기', style: TextStyle(fontSize: 12)),
      Icon(Icons.arrow_forward_ios, size: 12),
    ],
  ),
);

get qs3 => ElevatedButton(
  style: ElevatedButton.styleFrom(
    minimumSize: .zero,
    padding: .symmetric(vertical: 6, horizontal: 12),
    backgroundColor: .lerp(Colors.black, Colors.white, .05),
    foregroundColor: Colors.white,
  ),
  onPressed: () {},
  child: Text(album.genre, style: TextStyle(fontWeight: .bold, fontSize: 12)),
);
