import 'dart:async';

import 'package:creditask/graphql/api.dart';
import 'package:creditask/providers/graphql.dart';
import 'package:creditask/services/shopping_list.dart';
import 'package:creditask/widgets/_shared/creditask_drawer.dart';
import 'package:creditask/widgets/_shared/error_screen.dart';
import 'package:creditask/widgets/shopping_list/add/add_grocery_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ShoppingListContainer extends StatefulWidget {
  @override
  _ShoppingListContainerState createState() => _ShoppingListContainerState();
}

class _ShoppingListContainerState extends State<ShoppingListContainer> {
  RunMutation _runMutation;
  List<AllGroceriesInCart$Query$AllInCart> _groceries;
  String _queryKey;

  StreamSubscription<void> _subscription;

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final query = AllGroceriesInCartQuery();
    final mutation = UpdateGroceriesMutation();
    final theme = Theme.of(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: theme.primaryColor,
            child: Icon(
              Icons.check,
              color: theme.colorScheme.surface,
            ),
            onPressed: () {
              return _runMutation(
                UpdateGroceriesArguments(
                        input: _groceries
                            .map((e) => GroceryUpdateInput(
                                id: e.id,
                                inCart: e.inCart,
                                info: e.info,
                                name: e.name))
                            .toList())
                    .toJson(),
                optimisticResult: _groceries);
            }),
        drawer: const CreditaskDrawer(),
        appBar: AppBar(
          title: Text('Einkaufsliste'),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddGroceryScreen(_queryKey))))
          ],
        ),
        body: Mutation(
          options: MutationOptions(
              documentNode: mutation.document,
              fetchPolicy: FetchPolicy.cacheAndNetwork,
              update: (Cache cache, QueryResult result) {
                if (result.hasException) {
                  // TODO
                } else {
                  setState(() {
                    _groceries.forEach((e) {
                      final json = e.toJson();
                      cache.write(uuidFromObject(json), json);
                    });
                  });
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Änderung gespeichert'),
                      Icon(Icons.check, color: Colors.green)
                    ],
                  )));
                }
              },
              onError: (OperationException error) {
                // TODO
              }),
          builder: (runMutation, result) {
            _runMutation = runMutation;
            var _queryOptions = QueryOptions(documentNode: query.document);
            _queryKey = _queryOptions.toKey();
            return Query(
              options: _queryOptions,
              builder: (QueryResult result,
                  {VoidCallback refetch, FetchMore fetchMore}) {
                if (result.hasException) {
                  return ErrorDialog(result.exception.toString());
                }
                if (_subscription == null) {
                  _subscription = subscribeToGroceryDidChange(refetch);
                }

                if (result.loading) {
                  return Center(child: CircularProgressIndicator());
                }

                AllGroceriesInCart$Query queryData = query.parse(result.data);

                _groceries = queryData.allInCart
                    .where((element) => element.inCart)
                    .toList();
                if (_groceries.length < 1) {
                  return Center(
                    child: const Text('Keine Einkäufe zu machen 😎'),
                  );
                } else {
                  return StatefulBuilder(
                      builder: (context, setState) => ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          // + 1 to add an empty item at the end of the list so
                          // that the FAB won't block the last grocery item
                          itemCount: _groceries.length + 1,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          itemBuilder: (context, i) => i == _groceries.length
                              // empty dummy item
                              ? ListTile()
                              : CheckboxListTile(
                                  activeColor: theme.accentColor,
                                  value: !_groceries[i].inCart,
                                  selected: !_groceries[i].inCart,
                                  onChanged: (value) => setState(
                                      () => _groceries[i].inCart = !value),
                                  title: Text(_groceries[i].name),
                                  subtitle: Text(_groceries[i].info),
                                )));
                }
              },
            );
          },
        ));
  }
}
