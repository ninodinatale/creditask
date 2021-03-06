import 'package:creditask/graphql/api.dart';
import 'package:creditask/widgets/_shared/error_screen.dart';
import 'package:creditask/widgets/_shared/loadnig_button_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AddGroceryScreen extends StatefulWidget {
  final Request _request;

  const AddGroceryScreen(this._request);

  @override
  _AddGroceryScreenState createState() => _AddGroceryScreenState();
}

class _AddGroceryScreenState extends State<AddGroceryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final FocusNode _infoFocusNode = FocusNode();
  bool _isLoading = false;
  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _infoCtrl = TextEditingController();
  String _existingGroceryId;

  bool _isNewGrocery() {
    return _existingGroceryId == null;
  }

  Widget _getListTile(Grocery$Query$AllNotInCart grocery) {
    if (grocery == null) {
      return ListTile(
        leading: Icon(Icons.add),
        title: Text('Neu erstellen'),
      );
    } else {
      return ListTile(
        title: Text(grocery.name),
        subtitle: Text(grocery.info),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = GroceryQuery();
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Einkauf hinzufügen'),
        ),
        body: Query(
            options: QueryOptions(
                documentNode: query.document,
                fetchPolicy: FetchPolicy.cacheAndNetwork),
            builder: (QueryResult result,
                {VoidCallback refetch, FetchMore fetchMore}) {
              if (result.hasException) {
                return ErrorDialog(result.exception.toString());
              }

              if (result.loading) {
                return Center(child: CircularProgressIndicator());
              }
              Grocery$Query queryData = query.parse(result.data);
              final _createMutation = CreateGroceryMutation();
              final _updateMutation = UpdateGroceryMutation();
              final mutationOptions = MutationOptions(
                  fetchPolicy: FetchPolicy.cacheAndNetwork,
                  documentNode: _isNewGrocery()
                      ? _createMutation.document
                      : _updateMutation.document,
                  update: (GraphQLDataProxy cache, QueryResult result) {
                    if (result.hasException) {
                      return ErrorDialog(result.exception.toString());
                    } else {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                            content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Änderung gespeichert'),
                            Icon(Icons.check, color: Colors.green)
                          ],
                        )),
                      );

                      AllGroceriesInCart$Query _queryToUpdate =
                          AllGroceriesInCart$Query.fromJson(
                              cache.readQuery(widget._request));

                      if (_isNewGrocery()) {
                        _queryToUpdate.allInCart.add(
                            AllGroceriesInCart$Query$AllInCart.fromJson(
                                CreateGrocery$Mutation.fromJson(result.data)
                                    .createGrocery
                                    .grocery
                                    .toJson()));
                      } else {
                        _queryToUpdate.allInCart.add(
                            AllGroceriesInCart$Query$AllInCart.fromJson(
                                UpdateGrocery$Mutation.fromJson(result.data)
                                    .updateGrocery
                                    .grocery
                                    .toJson()));
                      }
                      cache.writeQuery(widget._request,
                          data: _queryToUpdate.toJson());

                      Navigator.of(context).pop();
                    }
                  },
                  onError: (OperationException error) {
                    // TODO
                  });
              return Mutation(
                options: mutationOptions,
                builder: (runMutation, result) => Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: TypeAheadFormField<Grocery$Query$AllNotInCart>(
                              validator: (value) => value.isEmpty ? 'Name darf nicht leer sein' : null,
                              textFieldConfiguration: TextFieldConfiguration(
                                decoration:
                                    const InputDecoration(labelText: 'Name'),
                                controller: _nameCtrl,
                                autofocus: true,
                              ),
                              suggestionsCallback: (pattern) => [
                                null,
                                ...queryData.allNotInCart
                                    .where((e) =>
                                        pattern.isEmpty ||
                                        e.name.contains(pattern))
                                    .toList()
                              ],
                              animationDuration: Duration(),
                              itemBuilder: (context, grocery) =>
                                  _getListTile(grocery),
                              onSuggestionSelected: (grocery) {
                                if (grocery == null) {
                                  setState(() {
                                    mutationOptions.document =
                                        _createMutation.document;
                                    _infoCtrl.text = '';
                                    _existingGroceryId = null;
                                    _infoFocusNode.requestFocus();
                                  });
                                } else {
                                  setState(() {
                                    mutationOptions.document =
                                        _updateMutation.document;
                                    _nameCtrl.text = grocery.name;
                                    _infoCtrl.text = grocery.info;
                                    _existingGroceryId = grocery.id;
                                  });
                                }
                              },
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              focusNode: _infoFocusNode,
                              decoration: InputDecoration(
                                labelText: 'Info',
                                helperText: 'Optional'
                              ),
                              controller: _infoCtrl,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: RaisedButton(
                              onPressed: this._isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState.validate()) {
                                        return runMutation(_isNewGrocery()
                                            ? CreateGroceryArguments(
                                                    input: GroceryCreateInput(
                                                        info: _infoCtrl.text,
                                                        name: _nameCtrl.text))
                                                .toJson()
                                            : UpdateGroceryArguments(
                                                    input: GroceryUpdateInput(
                                                        id: _existingGroceryId,
                                                        inCart: true,
                                                        info: _infoCtrl.text,
                                                        name: _nameCtrl.text))
                                                .toJson());
                                      }
                                    },
                              child:
                                  LoadingButtonContent(_isLoading, 'HINZUFÜGEN'),
                            ),
                          )
                        ],
                      ),
                    )),
              );
            }),
      ),
    );
  }
}
