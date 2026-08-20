import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinyl_groove_poc_13/app_ctrl.dart';
import 'package:vinyl_groove_poc_13/screeens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([.portraitDown, .portraitUp]);

  prefs = await SharedPreferences.getInstance();
  cameras = await availableCameras();

  appCtrl.init();

  runApp(MaterialApp(home: LoginScreen()));
}

message(m, {g = false}) => channelM.invokeMethod('t', {
  'm': g ? '$m 기능은 준비중입니다.\n나중에 다시 시도해 주세요.' : m ?? 'error',
});

final channelM = MethodChannel('com.example.vinyl_groove_poc_13_m');
late final SharedPreferences prefs;

List<CameraDescription> cameras = [];

const black = Color(0xff121212);
const black1 = Color(0xff101113);
const black2 = Color(0xff1E1E1E);
const black3 = Color(0xff2A2A2A);
const yellow = Color(0xffD4A54B);

const baseUrl = '10.53.68.44:8000';

get baseHeader => {
  'Content-Type': 'application/json',
  if (appCtrl.tkn != null) 'Authorization': 'Bearer ${appCtrl.tkn}',
};

extension QB on BuildContext {
  go(Widget page) =>
      Navigator.push(this, MaterialPageRoute(builder: (context) => page));

  re(Widget page) => Navigator.pushReplacement(
    this,
    MaterialPageRoute(builder: (context) => page),
  );

  back([r]) => Navigator.pop(this, r);
}

enum AppIcon {
  edit('edit.svg'),
  help('help.svg'),
  history('history.svg'),
  info('info.svg'),
  inventory('inventory.svg'),
  shopping('shopping-bag.svg'),
  barcode('barcode-scan.svg'),
  delete('delete.svg'),
  add('add.svg'),
  album('album.svg'),
  chevron('chevron-right.svg'),
  classical('classical.svg'),
  electronic('electronic.svg'),
  email('email.svg'),
  etc('etc.svg'),
  heart('heart.svg'),
  hip('hip-hop.svg'),
  home('home.svg'),
  jazz('jazz.svg'),
  lock('lock.svg'),
  mypage('mypage.svg'),
  notification('notification.svg'),
  person('person.svg'),
  pop('pop.svg'),
  rnb('rnb-soul.svg'),
  rock('rock.svg'),
  search('search.svg'),
  visibility('visibility.svg'),
  visibilityoff('visibility-off.svg');

  final String p;

  const AppIcon(this.p);

  SvgPicture icon({Color? color, double? size}) => SvgPicture.asset(
    'assets/icons/$p',
    color: color,
    width: size,
    height: size,
  );
}
