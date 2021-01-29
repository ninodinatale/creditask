import 'dart:async';

import 'package:creditask/graphql/api.dart';
import 'package:creditask/providers/graphql.dart';
import 'package:creditask/utils/jwt.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  CurrentUserMixin _currentUser;
  String _jwt;

  CurrentUserMixin get currentUser => _currentUser;

  Future<String> get jwt async {
    if (_jwt == null) {
      _jwt = await getJwt();
    }
    return _jwt;
  }

  Future<void> logout() async {
    FirebaseMessaging.instance.unsubscribeFromTopic('user_${_currentUser.id}');
    FirebaseMessaging.instance.unsubscribeFromTopic('group_${_currentUser.groupId}');
    _currentUser = null;
    _jwt = null;
    await deleteJwt();
    notifyListeners();
  }

  void setAuth(String jwt, CurrentUserMixin currentUser) {
    _currentUser = currentUser;
    _jwt = jwt;

    // this can be sync since we set the jwt above.
    setJwt(jwt);

    notifyListeners();
  }

  Future<bool> isLoggedIn() async {
    final token = await jwt;
    var _isLoggedIn = false;
    if (token != null) {
      await artemisClient
          .execute(VerifyTokenMutation(
              variables: VerifyTokenArguments(token: token)))
          .then((result) async {
        if (result.hasErrors) {
          await logout();
        } else {
          if (_currentUser?.id != result.data.verifyToken.user.id) {
            _currentUser = result.data.verifyToken.user;
            notifyListeners();
          }
          _isLoggedIn = true;
        }
      });
    }
    return _isLoggedIn;
  }
}
