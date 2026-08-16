get asd =>
    TextButton(
      style: TextButton.styleFrom(
        padding: .zero,
        minimumSize: .zero,
        foregroundColor: Colors.white60,
      ),
      onPressed: () {},
      child: Text('비밀번호를 잊으셨나요?'),
    )
,


//

get dsfa =>
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: yellow,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(12),
        ),
        padding: .symmetric(vertical: 16),
      ),
      onPressed: () {},
      child: Row(
        mainAxisAlignment: .center,
        children: [
          Text(
            '로그인',
            style: TextStyle(fontWeight: .bold, fontSize: 16),
          ),
        ],
      ),
    );

get sadfasd =>
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: act
            ? Colors.black
            : Colors.white,
        backgroundColor: act ? yellow : black3,
        minimumSize: .zero,
        padding: .symmetric(
          vertical: 8,
          horizontal: 12,
        ),
      ),
      onPressed: () {},
      child: Text(
        '로그인',
        style: TextStyle(
          fontWeight: .bold,
          fontSize: 12,
        ),
      ),
    );

get asdfadsf =>
    IconButton(
      style: IconButton.styleFrom(
        backgroundColor: Colors.black54,
        foregroundColor: Colors.white,
      ),
      onPressed: () {},
      icon: Icon(Icons.arrow_back),
    );
