import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../const.dart';

class Config {
  static ValueNotifier<GraphQLClient> initClient() {
    HttpLink httpLink = HttpLink(
      hasuraServer,
    );

    WebSocketLink websocketLink = WebSocketLink(
      hasuraWebSocketServer,
      config: SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: const Duration(seconds: 60),
        initialPayload: {
          'headers': {
            'X-Hasura-Admin-Secret': hasuraAdminSecret,
          }
        },
      ),
    );

    final Link link = websocketLink.concat(httpLink);

    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(
          store: HiveStore(),
        ),
        link: link,
      ),
    );
    return client;
  }
}
