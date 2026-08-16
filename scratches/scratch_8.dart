Material
(
color: black,
child: InkWell(
onTap: () {
context.go(AlbumScreen(id: e.id));
},
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Row(
spacing: 12,
children: [
ClipRRect(
borderRadius: .circular(12),
child: Image.network(
e.albumImage,
height: 72,
width: 72,
fit: .cover,
),
),

Expanded(
child: Column(
crossAxisAlignment: .start,
spacing: 4,
children: [
Text(
e.albumName,
overflow: .ellipsis,
style: TextStyle(
color: Colors.white,
fontWeight: .bold,
fontSize: 14,
),
),
Text(
e.artist,
overflow: .ellipsis,
style: TextStyle(
color: Colors.white60,
fontSize: 13,
),
),
Row(
spacing: 8,
children: [
Container(
decoration:
BoxDecoration(
color: Colors
    .black54,
borderRadius:
    .circular(4),
),
padding: .symmetric(
horizontal: 6,
vertical: 2,
),
child: Text(
e.condition,
style: TextStyle(
color: Colors.white,
fontWeight: .bold,
fontSize: 10,
),
),
),

Text(
e.genre.l,
overflow: .ellipsis,
style: TextStyle(
color: Colors.white60,
fontSize: 12,
),
),
],
),
],
),
),

Padding(
padding: const EdgeInsets.all(
8.0,
),
child: Column(
crossAxisAlignment: .end,
spacing: 4,
children: [
Text(
NumberFormat(
'₩ #,###',
).format(e.price),
style: TextStyle(
color: yellow,
fontWeight: .bold,
fontSize: 15,
),
),
Text(
e.tradeMethod.l,
style: TextStyle(
color: Colors.white60,
fontSize: 12,
),
),
],
),
),
],
),
),
),
)