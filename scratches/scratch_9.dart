AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            style: IconButton.styleFrom(),
            onPressed: () {
              context.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Text(
            '관심 상품',
            style: TextStyle(color: Colors.white, fontWeight: .bold),
          ),
        )