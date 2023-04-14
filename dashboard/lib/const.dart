import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

late ValueNotifier<GraphQLClient> client;

late String hasuraServer;
late String hasuraWebSocketServer;
late String hasuraAdminSecret;
