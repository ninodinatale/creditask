import 'dart:async';
import 'dart:io';

import 'package:artemis/artemis.dart';
import 'package:creditask/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

String get _host {
  final _prodUrl = 'https://creditask.herokuapp.com';
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:8000'; // for development
    // return _prodUrl;
  } else {
    return 'http://localhost:8000'; // for development
    // return _prodUrl;
  }
}

String get _graphqlUri => '$_host/graphql';

ArtemisClient artemisClient;

class AuthenticatedClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final AuthProvider _auth;

  AuthenticatedClient(AuthProvider auth) : _auth = auth;

  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers['Authorization'] = 'Jwt ${await _auth.jwt}';
    return _inner.send(request);
  }
}

String uuidFromObject(Object object) {
  if (object is Map<String, Object>) {
    final String typeName = object['__typename'] as String;
    final String id = object['id'].toString();
    if (typeName != null && id != null) {
      return <String>[typeName, id].join('/');
    }
  }
  return null;
}

final OptimisticCache cache = OptimisticCache(
  dataIdFromObject: uuidFromObject,
);

ValueNotifier<GraphQLClient> clientFor({
  @required AuthProvider auth,
  @required String uri,
  String subscriptionUri,
}) {
  HttpLink httpLink = HttpLink(uri: uri);
  AuthLink authLink = AuthLink(getToken: () async {
    return 'Jwt ${await auth.jwt}';
  });

  Link link = authLink.concat(httpLink);

  if (subscriptionUri != null) {
    final WebSocketLink websocketLink = WebSocketLink(
      url: subscriptionUri,
      config: SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: Duration(seconds: 30),
      ),
    );

    link = link.concat(websocketLink);
  }

  artemisClient = ArtemisClient(
    uri,
    httpClient: AuthenticatedClient(auth),
  );

  return ValueNotifier<GraphQLClient>(
    GraphQLClient(
      cache: cache,
      link: link,
    ),
  );
}

/// Wraps the root application with the `graphql_flutter` client.
/// We use the cache for all state management.
class GraphqlProvider extends StatelessWidget {
  GraphqlProvider({
    @required this.child,
    this.subscriptionUri,
  });

  final Widget child;
  final String subscriptionUri;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return GraphQLProvider(
      client: clientFor(
        auth: auth,
        uri: _graphqlUri,
        subscriptionUri: subscriptionUri,
      ),
      child: child,
    );
  }
}
