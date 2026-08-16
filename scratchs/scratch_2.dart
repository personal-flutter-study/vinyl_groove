TextField
(
controller: em,
style: TextStyle(color: Colors.white),
decoration: InputDecoration(
border: OutlineInputBorder(borderRadius: .circular(12)),
prefixIcon: Padding(
padding: const EdgeInsets.all(10.0),
child: AppIcon.email.icon(color: Colors.white60),
),
hintStyle: TextStyle(color: Colors.white60),
hintText: '이메일을 입력해주세요.',
filled: true,
fillColor: black1,
),
),