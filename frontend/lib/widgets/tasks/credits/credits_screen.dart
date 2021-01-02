import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphql/api.dart';
import '../../_shared/error_screen.dart';

class CreditsScreen extends StatefulWidget {
  @override
  _CreditsScreenState createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  @override
  Widget build(BuildContext context) {
    CreditsQuery query = CreditsQuery();
    return Query(
      options: QueryOptions(
        documentNode: query.document,
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.hasException) {
          return ErrorDialog(result.exception.toString());
        }

        if (result.loading) {
          return Center(child: CircularProgressIndicator());
        }

        Credits$Query queryData = query.parse(result.data);

        return DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Credits',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: queryData.users
                .map((e) => DataRow(cells: <DataCell>[
                      DataCell(Text(e.publicName)),
                      DataCell(Text(e.credits.toString()))
                    ]))
                .toList());
      },
    );
  }
}
