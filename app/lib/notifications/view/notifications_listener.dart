import 'package:fasting_app/notifications/bloc/notifications_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsListener extends StatelessWidget {
  final Widget child;

  const NotificationsListener({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) =>
      BlocListener<NotificationsBloc, NotificationsState>(
        listener: (context, state) {},
        child: child,
      );
}
