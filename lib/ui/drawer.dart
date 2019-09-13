import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var emailStyle =
        Theme.of(context).textTheme.body2.copyWith(color: Colors.white);

    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromState,
      builder: (context, vm) {
        return SizedBox(
          width: 220.0,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 140.0,
                  child: DrawerHeader(
                    child: Center(child: Text(vm.email, style: emailStyle)),
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Sign out',
                      style: Theme.of(context).textTheme.body2),
                  trailing: Icon(Icons.exit_to_app),
                  onTap: () {
                    Navigator.of(context).pop();
                    vm.signOut();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final Function signOut;
  final String email;

  _ViewModel({
    @required this.signOut,
    @required this.email,
  });

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      signOut: () => store.dispatch(SignOut()),
      email: getUserEmail(store.state),
    );
  }
}