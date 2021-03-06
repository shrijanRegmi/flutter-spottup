import 'package:flutter/material.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:provider/provider.dart';

class VmProvider<T extends ChangeNotifier> extends StatefulWidget {
  @override
  _VmProviderState<T> createState() => _VmProviderState<T>();

  final T vm;
  final Widget Function(BuildContext context, T vm, AppUser appUser) builder;
  final Function(T vm) onInit;

  VmProvider({@required this.vm, @required this.builder, this.onInit});
}

class _VmProviderState<T extends ChangeNotifier> extends State<VmProvider<T>> {
  @override
  void initState() {
    super.initState();
    if (widget.onInit != null) {
      widget.onInit(widget.vm);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return ChangeNotifierProvider<T>(
      create: (_) => widget.vm,
      child: Consumer<T>(
        builder: (BuildContext context, T value, Widget child) {
          return widget.builder(context, value, _appUser);
        },
      ),
    );
  }
}
