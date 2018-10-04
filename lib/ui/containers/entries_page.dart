import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/actions/actions.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/models/state.dart';
import 'package:sink/ui/presentation/entry_list.dart';

class EntryListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromState,
      builder: (context, vm) {
        return EntryList(
          onDismissed: vm.onDismissed,
          onUndo: vm.onUndo,
        );
      },
    );
  }
}

@immutable
class _ViewModel {
  final Function(Entry) onDismissed;
  final Function onUndo;

  _ViewModel(
      {@required this.onDismissed,
      @required this.onUndo});

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      onDismissed: (entry) => store.dispatch(DeleteEntry(entry)),
      onUndo: () => store.dispatch(UndoDelete()),
    );
  }
}