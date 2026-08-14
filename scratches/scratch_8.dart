Material(
color: black2,
shape: RoundedRectangleBorder(
borderRadius: .circular(12),
),
child: InkWell(
onTap: () {
context.go(AlbumScreen(id: e.id));
},
child: Row(
spacing: 12,
children: [
ClipRRect(
borderRadius: .circular(12),
child: Image.network(
e.albumImage,
fit: .cover,
width: 64,
height: 64,
),
),

Expanded(
child: Column(
spacing: 4,
crossAxisAlignment: .start,
children: [
Text(
e.albumName,
overflow: .ellipsis,
style: TextStyle(
color: Colors.white,
fontWeight: .bold,
fontSize: 15,
),
),
Text(
e.artist,
overflow: .ellipsis,
style: TextStyle(
color: yellow,
fontSize: 12,
),
),

Text(
'${e.genre.l} • ${e.condition}',
overflow: .ellipsis,
style: TextStyle(
color: Colors.white60,
fontSize: 12,
),
),
],
),
),

Padding(
padding: const EdgeInsets.all(8.0),
child: Icon(
Icons.arrow_forward_ios,
color: Colors.white60,
size: 16,
),
),
],
),
),
)