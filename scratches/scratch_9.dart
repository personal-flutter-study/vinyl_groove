AppBar
(
automaticallyImplyLeading: false,
leading: IconButton(
style: IconButton.styleFrom(),
onPressed: () {
context.back();
},
icon: Icon(Icons.arrow_back, color: Colors.white),
),
backgroundColor: Colors.transparent,
title: Text(
'관심 상품',
style: TextStyle(color: Colors.white, fontWeight: .bold),
),
)