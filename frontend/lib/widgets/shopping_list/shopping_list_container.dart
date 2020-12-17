import 'dart:async';

import 'package:creditask/graphql/api.dart';
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
  VoidCallback _refetch;
  void Function(void Function()) _setFabState;
  List<AllGroceriesInCart$Query$AllInCart> _groceries = List.empty();

  StreamSubscription<void> _subscription;

  QueryOptions _queryOptions;

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  bool _hasSelected() {
    return _groceries.any((element) => !element.inCart);
  }

  @override
  Widget build(BuildContext context) {
    final query = AllGroceriesInCartQuery();
    final mutation = UpdateGroceriesMutation();
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
          floatingActionButton: StatefulBuilder(
            builder: (context, setState) {
              _setFabState = setState;
              return FloatingActionButton(
                  backgroundColor:
                      _hasSelected() ? theme.primaryColor : theme.disabledColor,
                  child: Icon(
                    Icons.check,
                    color: theme.colorScheme.surface,
                  ),
                  onPressed: !_hasSelected()
                      ? null
                      : () {
                          if (_hasSelected()) {
                            _runMutation(
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
                          }
                        });
            },
          ),
          drawer: const CreditaskDrawer(),
          appBar: AppBar(
            title: Text('Einkaufsliste'),
            actions: [
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddGroceryScreen(_queryOptions.asRequest))))
            ],
          ),
          body: Mutation(
            options: MutationOptions(
                document: mutation.document,
                fetchPolicy: FetchPolicy.cacheAndNetwork,
                update: (GraphQLDataProxy cache, QueryResult result) {
                  if (result.hasException) {
                    // TODO
                  } else {
                    // TODO this somehow does only work the first time, after that,
                    //  `inCart` is still true even though it's set in `onChanged`
                    //  down below. Just refetching for now, but updating cache
                    //  is yet TODO
                    // final _query = AllGroceriesInCart$Query()..allInCart = _groceries;
                    //   cache.writeQuery(_queryOptions.asRequest,
                    //       data: _query.toJson());

                    // TODO remove refetch if issue above is resolved
                    _refetch();

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
              _queryOptions = QueryOptions(document: query.document);
              return Query(
                options: _queryOptions,
                builder: (QueryResult result,
                    {VoidCallback refetch, FetchMore fetchMore}) {
                  _refetch = refetch;
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
                                    onChanged: (value) {
                                      setState(
                                          () => _groceries[i].inCart = !value);
                                      _setFabState(() {});
                                    },
                                    title: Text(_groceries[i].name),
                                    subtitle: Text(_groceries[i].info),
                                  )));
                  }
                },
              );
            },
          )),
    );
  }
}
