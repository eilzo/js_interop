// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:js_interop';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

Future initJSInterop() async {
  final interopStateManager = DemoAppStateManager();

  final export = createDartExport(interopStateManager);

  /// Locates the root of the flutter app (for now, the first element that has
  /// a flt-renderer tag), and dispatches a JS event named [name] with [data].
  final DomElement? root = document.querySelector('[flt-renderer]');
  assert(root != null, 'Flutter root element cannot be found!');

  dispatchCustomEvent(root!, 'flutter-initialized', export);
}

/// This is a little bit of JS-interop code so this Flutter app can dispatch
/// a custom JS event.
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
