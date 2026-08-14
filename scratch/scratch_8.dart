Material(
type: .transparency,
child: Row(
spacing: 12,
children: [
ClipRRect(
borderRadius: .circular(12),
child: Image.network(
e.albumImage,
width: 60,
height: 60,
fit: .cover,
),
),

Expanded(
child: Column(
crossAxisAlignment: .start,
children: [
Text(
e.albumName,
style: TextStyle(
color: Colors.white,
fontWeight: .bold,
),
),
Text(
e.artist,
style: TextStyle(color: yellow),
),
Text(
'${e.genre.l} • ${e.condition}',
style: TextStyle(
color: Colors.white60,
fontSize: 12,
),
),
],
),
),

Icon(
Icons.arrow_forward_ios,
size: 18,
color: Colors.white,
),
],
),
)