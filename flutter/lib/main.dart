import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';
import 'dart:js_interop';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  await FlutterFlowTheme.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
// This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  late final DemoAppStateManager _state;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    _state = DemoAppStateManager();

    final export = createDartExport(_state);

    /// Locates the root of the flutter app (for now, the first element that has
    /// a flt-renderer tag), and dispatches a JS event named [name] with [data].

    final DomElement? root = document.querySelector('[flt-renderer]');
    assert(root != null, 'Flutter root element cannot be found!');

    dispatchCustomEvent(root!, 'flutter-initialized', export);
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return MaterialApp.router(
      title: 'JS Interop Example',
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        scrollbarTheme: ScrollbarThemeData(),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scrollbarTheme: ScrollbarThemeData(),
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

/// This is a little bit of JS-interop code so this Flutter app can dispatch
/// a custom JS event (to be deprecated by package:web)

@JS('CustomEvent')
@staticInterop
class DomCustomEvent {
  external factory DomCustomEvent.withType(JSString type);
  external factory DomCustomEvent.withOptions(JSString type, JSAny options);
  factory DomCustomEvent._(String type, [Object? options]) {
    if (options != null) {
      return DomCustomEvent.withOptions(type.toJS, jsify(options) as JSAny);
    }
    return DomCustomEvent.withType(type.toJS);
  }
}

dispatchCustomEvent(DomElement target, String type, Object data) {
  final DomCustomEvent event = DomCustomEvent._(type, <String, Object>{
    'bubbles': true,
    'composed': true,
    'detail': data,
  });

  target.dispatchEvent(event);
}

@JS()
@staticInterop
class DomEventTarget {}

extension DomEventTargetExtension on DomEventTarget {
  @JS('dispatchEvent')
  external JSBoolean _dispatchEvent(DomCustomEvent event);
  bool dispatchEvent(DomCustomEvent event) => _dispatchEvent(event).toDart;
}

@JS()
@staticInterop
class DomElement extends DomEventTarget {}

extension DomElementExtension on DomElement {
  @JS('querySelector')
  external DomElement? _querySelector(JSString selectors);
  DomElement? querySelector(String selectors) => _querySelector(selectors.toJS);
}

@JS()
@staticInterop
class DomDocument extends DomElement {}

@JS()
@staticInterop
external DomDocument get document;

/// This is the bit of state that JS is able to see.
///
/// It contains getters/setters/operations and a mechanism to
/// subscribe to change notifications from an incoming [notifier].
@JSExport()
class DemoAppStateManager {
// Allows clients to subscribe to changes to the wrapped value.

  // Counter functions
  int getClicks() {
    return FFAppState().counter;
  }

  void setClicks(int value) {
    FFAppState().update(
      () => FFAppState().counter = value,
    );
  }

  void onClicksChanged(Function(int) f) {
    FFAppState().addListener(() {
      f(getClicks());
    });
  }

  // Text field methods
  String getText() {
    return FFAppState().text;
  }

  void setText(String text) {
    FFAppState().update(
      () => FFAppState().text = text,
    );
  }

  void onTextChanged(Function(String) f) {
    FFAppState().addListener(() {
      f(getText());
    });
  }

  // Color methods
  void setColor(String color) {
    FFAppState().update(
      () => FFAppState().color = color,
    );
  }

  String getColor() {
    return FFAppState().color;
  }

  void onColorChanged(Function(String) f) {
    FFAppState().addListener(() {
      f(getColor());
    });
  }
}
