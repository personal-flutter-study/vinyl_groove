import '../app_ctrl.dart';

class AlbumModel {
  final int id;
  final String albumName;
  final String artist;
  final Genre genre;
  final String condition;
  final int price;
  final Trade tradeMethod;
  final String albumImage;
  final int likeCount;
  final String createdAt;

  AlbumModel({
    required this.id,
    required this.albumName,
    required this.artist,
    required this.genre,
    required this.condition,
    required this.price,
    required this.tradeMethod,
    required this.albumImage,
    required this.likeCount,
    required this.createdAt,
  });

  factory AlbumModel.from(j) => AlbumModel(
    id: j['id'],
    albumName: j['albumName'],
    artist: j['artist'],
    genre: Genre.values.where((e) => e.v == j['genre']).first,
    condition: j['condition'],
    price: j['price'],
    tradeMethod: Trade.values
        .where((element) => element.v == j['tradeMethod'])
        .first,
    albumImage: j['albumImage'],
    likeCount: j['likeCount'] ?? 0,
    createdAt: j['createdAt'],
  );

  toJson() => {
    'id': id,
    'albumName': albumName,
    'artist': artist,
    'genre': genre.v,
    'condition': condition,
    'price': price,
    'tradeMethod': tradeMethod.v,
    'albumImage': albumImage,
    'likeCount': likeCount,
    'createdAt': createdAt,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlbumModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/*

{
    "success": true,
    "data": {
        "id": 1,
        "albumName": "Blonde",
        "artist": "Frank Ocean",
        "genre": "RNB_SOUL",
        "condition": "M",
        "conditionDescription": "Mint. 개봉했으나 새것과 다름없는 완벽한 상태입니다.",
        "price": 95000,
        "tradeMethod": "DIRECT",
        "description": "한정판 블랙 프라이데이 에디션. 희귀본.",
        "albumImage": "https://api.vinylgroove.com/images/album/blonde.jpg",
        "seller": {
            "id": 10,
            "name": "Analog Shop",
            "email": "analog@example.com",
            "profileImage": "https://api.vinylgroove.com/images/profile/seller010.jpg"
        },
        "likeCount": 320,
        "createdAt": "2026-05-20T10:00:00Z"
    }
}

{
"success": true,
"data": [
{
"id": 1,
"albumName": "Blonde",
"artist": "Frank Ocean",
"genre": "RNB_SOUL",
"condition": "M",
"price": 95000,
"tradeMethod": "DIRECT",
"albumImage": "https://api.vinylgroove.com/images/album/blonde.jpg",
"likeCount": 320,
"createdAt": "2026-05-20T10:00:00Z"
}
],
"pagination": { "page": 1, "size": 12, "totalCount": 50, "totalPages": 5, "hasNext": true }
}*/
