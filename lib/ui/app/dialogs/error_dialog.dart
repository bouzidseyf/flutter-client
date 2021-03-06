import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/redux/app/app_actions.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/redux/auth/auth_actions.dart';
import 'package:invoiceninja_flutter/utils/dialogs.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:invoiceninja_flutter/.env.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog(this.error, {this.clearErrorOnDismiss = false});

  final Object error;
  final bool clearErrorOnDismiss;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final store = StoreProvider.of<AppState>(context);

    return AlertDialog(
      title: Text(localization.anErrorOccurred),
      content: error != null ? Text(error.toString()) : SizedBox(),
      actions: [
        if (clearErrorOnDismiss && !Config.DEMO_MODE)
          FlatButton(
              child: Text(localization.logout.toUpperCase()),
              onPressed: () {
                confirmCallback(
                    context: context,
                    callback: () {
                      store.dispatch(UserLogout(context));
                    });
              }),
        FlatButton(
            child: Text(localization.copy.toUpperCase()),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: '$error'));
            }),
        FlatButton(
            child: Text(localization.dismiss.toUpperCase()),
            onPressed: () {
              if (clearErrorOnDismiss) {
                store.dispatch(ClearLastError());
              }
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}
