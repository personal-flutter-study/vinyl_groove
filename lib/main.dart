import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinyl_groove_poc_1/app_ctrl.dart';
import 'package:vinyl_groove_poc_1/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  prefs = await SharedPreferences.getInstance();

  runApp(MaterialApp(home: LoginScreen()));
}

List<CameraDescription> cameras = [];

const yellow = Color(0xffD3A44B);
const black = Color(0xff121212);
const blackAccent = Color(0xff1E1E1E);

late final SharedPreferences prefs;

const baseUrl = '10.0.2.2:8001';

get jsonHeader => {'Content-Type': 'application/json'};

get authHeader => {'Authorization': 'Bearer ${appCtrl.tkn}'};

final channelM = MethodChannel('com.example.vinyl_groove_poc_1_m');

extension QB on BuildContext {
  Future<dynamic> go(Widget page) =>
      Navigator.push(this, MaterialPageRoute(builder: (context) => page));

  back() => Navigator.pop(this);

  message(m) => channelM.invokeMethod('t', {'m': m});
}

enum AppIcon {
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
  barcodescan('barcode-scan.svg'),
  delete('delete.svg'),
  visibilityoff('visibility-off.svg');

  final String p;

  const AppIcon(this.p);

  icon({Color? color, double? width}) => SvgPicture.asset(
    'assets/icons/$p',
    color: color,
    width: width,
    height: width,
    fit: .contain,
  );
}
