// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:js' if (dart.library.io) 'dummy_js.dart' as js;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class RouteHandler extends ChangeNotifier {
  static final RouteHandler _routeHandler = RouteHandler._internal();

  factory RouteHandler() => _routeHandler;

  RouteHandler._internal();

  final Map<String, String> _urlFixQue = {};

  String currenPATH = '';

  /// this is faster than the switch tabs methods only use when you are sure that you
  /// are either going to append or replace the last path in the browser URL
  void switchTabsLast(int currIdx, Set<String> tabs) {
    String currentLocation = _getCurrentPath();
    String lastPath = '';
    int idx = currentLocation.length - 1;
    for (; currentLocation[idx] != '/'; idx--) {
      lastPath = currentLocation[idx] + lastPath;
    }
    if (tabs.contains(lastPath)) {
      _updateState(
          currentLocation.substring(0, idx + 1) + tabs.elementAt(currIdx));
    } else {
      _updateState('$currentLocation/${tabs.elementAt(currIdx)}');
    }
  }

  /// works for nested shell cubit
  void switchTabs(int currIdx, Set<String> tabs, int? pathPosition) {
    String currentLocation = _getCurrentPath();
    List<String> paths = currentLocation.split('/');
    String newPath = tabs.elementAt(currIdx);
    int? pathIdx;
    if (pathPosition != null) {
      pathIdx = pathPosition;
    } else {
      for (int idx = paths.length - 1; idx > 0; idx--) {
        if (tabs.contains(paths[idx])) {
          pathIdx = idx;
          break;
        }
      }
    }

    if (pathIdx != null) {
      paths[pathIdx] = newPath;
      _updateState(paths.join('/'));
    } else {
      _updateState('${paths.join('/')}/$newPath');
    }
  }

  void addURLFixToQue(String currPath, String newPath) {
    _urlFixQue[currPath] = newPath;
  }

  /// ONLY WORKS FOR WEB
  /// Fixes the browser's mistyped URL paths
  void fixUrl() {
    if (_urlFixQue.isEmpty || !kIsWeb) return;
    String currentLocation = _getCurrentPath();
    List<String> paths = currentLocation.split('/');
    for (int idx = 0; idx < paths.length; idx++) {
      if (_urlFixQue.containsKey(paths[idx])) {
        paths[idx] = _urlFixQue[paths[idx]]!;
      }
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      _updateState(paths.join('/'));
      _urlFixQue.clear();
    });
  }

  String _getCurrentPath() {
    if (!kIsWeb) return '';
    return js.context['location']['pathname'];
  }

  // ONLY WORKS FOR WEB
  // Updates the browser url path
  void updateURLPath(String path) => _updateState(path);

  void _updateState(String curr) {
    if (!kIsWeb) return;
    currenPATH = curr;
    if (hasListeners) {
      notifyListeners();
    }
    (js.context['history'] as js.JsObject)
        .callMethod('replaceState', [null, '', curr]);
  }

  // ONLY WORKS FOR WEB
  // pass the redirection time in milliseconds
  void redirect(String redirectPath, {int? redirectionTime}) {
    Future.delayed(Duration(milliseconds: redirectionTime ?? 0), () {
      if (!kIsWeb) return;
      (js.context['location'] as js.JsObject)
          .callMethod('replace', [redirectPath]);
    });
  }
}
