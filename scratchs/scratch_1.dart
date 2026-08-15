TextField(
style: TextStyle(color: Colors.white),
controller: em,
decoration: InputDecoration(
fillColor: black1,
filled: true,
border: OutlineInputBorder(borderRadius: .circular(12)),
focusedBorder: OutlineInputBorder(
borderRadius: .circular(12),
borderSide: BorderSide(color: yellow),
),
hintStyle: TextStyle(color: Colors.white60),
hintText: '이메일을 입력해주세요.',
prefixIcon: Padding(
padding: const EdgeInsets.all(11.0),
child: AppIcon.email.icon(color: Colors.white60),
),
),
)