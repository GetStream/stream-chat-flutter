import 'dart:async';

import 'package:example/choose_user_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'app_config.dart';
import 'notifications_service.dart';
import 'routes/app_routes.dart';
import 'routes/routes.dart';

final chatPersistentClient = StreamChatPersistenceClient(
  logLevel: Level.SEVERE,
  connectionMode: ConnectionMode.background,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  InitData? _initData;
  bool _animCompleted = false;
  Animation<double>? _animation, _scaleAnimation;
  AnimationController? _animationController, _scaleAnimationController;
  Animation<Color?>? _colorAnimation;
  late int timeOfStartMs;

  Future<InitData> _initConnection() async {
    String? apiKey, userId, token;

    if (!kIsWeb) {
      final secureStorage = FlutterSecureStorage();
      apiKey = await secureStorage.read(key: kStreamApiKey);
      userId = await secureStorage.read(key: kStreamUserId);
      token = await secureStorage.read(key: kStreamToken);
    }

    final client = StreamChatClient(
      apiKey ?? kDefaultStreamApiKey,
      logLevel: Level.INFO,
    )..chatPersistenceClient = chatPersistentClient;

    if (userId != null && token != null) {
      await client.connectUser(
        User(id: userId),
        token,
      );
    }

    final prefs = await StreamingSharedPreferences.instance;

    return InitData(client, prefs);
  }

  void _createAnimations() {
    _scaleAnimationController = AnimationController(
      vsync: this,
      value: 0,
      duration: Duration(
        milliseconds: 500,
      ),
    );
    _scaleAnimation = Tween(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _scaleAnimationController!,
      curve: Curves.easeInOutBack,
    ));

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 1000,
      ),
    );
    _animation = Tween(
      begin: 0.0,
      end: 1000.0,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ));
    _colorAnimation = ColorTween(
      begin: Color(0xff005FFF),
      end: Color(0xff005FFF),
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ));
    _colorAnimation = ColorTween(
      begin: Color(0xff005FFF),
      end: Colors.transparent,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void initState() {
    timeOfStartMs = DateTime.now().millisecondsSinceEpoch;

    _createAnimations();

    _initConnection().then(
      (initData) {
        setState(() {
          _initData = initData;
        });

        var now = DateTime.now().millisecondsSinceEpoch;

        if (now - timeOfStartMs > 1500) {
          SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
            _scaleAnimationController?.forward().whenComplete(() {
              _animationController?.forward();
            });
          });
        } else {
          Future.delayed(Duration(milliseconds: 1500)).then((value) {
            _scaleAnimationController?.forward().whenComplete(() {
              _animationController?.forward();
            });
          });
        }

        if (!kIsWeb) {
          _initData!.client.state.totalUnreadCountStream.listen((count) {
            if (count > 0) {
              FlutterAppBadger.updateBadgeCount(count);
            } else {
              FlutterAppBadger.removeBadge();
            }
          });
        }
      },
    );
    _animationController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _animCompleted = true;
        });
      }
    });

    super.initState();
  }

  Widget _buildAnimation() {
    return MaterialApp(
      home: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation!,
            builder: (context, _) {
              return Transform.scale(
                scale: _scaleAnimation!.value,
                child: AnimatedBuilder(
                    animation: _colorAnimation!,
                    builder: (context, snapshot) {
                      return Container(
                        alignment: Alignment.center,
                        constraints: BoxConstraints.expand(),
                        color: _colorAnimation == null
                            ? Color(0xff005FFF)
                            : _colorAnimation!.value,
                        child: !_animationController!.isAnimating
                            ? Lottie.asset(
                                'assets/floating_boat.json',
                                alignment: Alignment.center,
                              )
                            : SizedBox(),
                      );
                    }),
              );
            },
          ),
          AnimatedBuilder(
            animation: _animation!,
            builder: (context, snapshot) {
              return Transform.scale(
                scale: _animation!.value,
                child: Container(
                  width: 1.0,
                  height: 1.0,
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(1 - _animationController!.value),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_initData != null)
          PreferenceBuilder<int>(
            preference: _initData!.preferences.getInt(
              'theme',
              defaultValue: 0,
            ),
            builder: (context, snapshot) => MaterialApp(
              builder: (context, child) {
                return StreamChat(
                  backgroundKeepAlive: Duration(seconds: 5),
                  client: _initData!.client,
                  onBackgroundEventReceived: (e) => showLocalNotification(
                      e, _initData!.client.state.user!.id),
                  child: Builder(
                    builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
                      child: child!,
                      value: SystemUiOverlayStyle(
                        systemNavigationBarColor:
                            StreamChatTheme.of(context).colorTheme.white,
                        systemNavigationBarIconBrightness:
                            Theme.of(context).brightness == Brightness.dark
                                ? Brightness.light
                                : Brightness.dark,
                      ),
                    ),
                  ),
                );
              },
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: {
                -1: ThemeMode.dark,
                0: ThemeMode.system,
                1: ThemeMode.light,
              }[snapshot],
              onGenerateRoute: AppRoutes.generateRoute,
              initialRoute: _initData!.client.state.user == null
                  ? Routes.CHOOSE_USER
                  : Routes.HOME,
            ),
          ),
        if (!_animCompleted) _buildAnimation(),
      ],
    );
  }
}

class InitData {
  final StreamChatClient client;
  final StreamingSharedPreferences preferences;

  InitData(this.client, this.preferences);
}

class HolePainter extends CustomPainter {
  HolePainter({
    required this.color,
    required this.holeSize,
  });

  Color color;
  double holeSize;

  @override
  void paint(Canvas canvas, Size size) {
    double radius = holeSize / 2;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Rect outerCircleRect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius);
    Rect innerCircleRect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius / 2);

    Path transparentHole = Path.combine(
      PathOperation.difference,
      Path()..addRect(rect),
      Path()
        ..addOval(outerCircleRect)
        ..close(),
    );

    Path halfTransparentRing = Path.combine(
      PathOperation.difference,
      Path()
        ..addOval(outerCircleRect)
        ..close(),
      Path()
        ..addOval(innerCircleRect)
        ..close(),
    );

    canvas.drawPath(transparentHole, Paint()..color = color);
    canvas.drawPath(
        halfTransparentRing, Paint()..color = color.withOpacity(0.5));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
