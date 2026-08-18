Material(
color: black,
clipBehavior: .antiAlias,
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
clipBehavior: .antiAlias,
borderRadius: .circular(12),
child: Image.network(
e.albumImage,
width: 72,
height: 72,
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
style: TextStyle(
color: Colors.white,
fontWeight: .bold,
fontSize: 15,
),
),
Text(
e.artist,
style: TextStyle(
color: Colors.white60,
fontSize: 14,
),
),

Row(
spacing: 8,
children: [
Container(
padding: .symmetric(
horizontal: 8,
vertical: 4,
),
decoration: BoxDecoration(
color: Colors.black87,
borderRadius: .circular(
4,
),
),
child: Text(
e.condition,
style: TextStyle(
color: Colors.white,
fontSize: 10,
fontWeight: .w500,
),
),
),

Text(
e.genre.l,
style: TextStyle(
color: Colors.white38,
fontWeight: .w500,
fontSize: 12,
),
),
],
),
],
),
),

Column(
spacing: 4,
crossAxisAlignment: .end,
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
e.genre.l,
style: TextStyle(
color: Colors.white30,
fontSize: 12,
),
),
],
),
],
),
),
),
)