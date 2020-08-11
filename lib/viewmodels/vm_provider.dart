import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VmProvider<T extends ChangeNotifier> extends StatefulWidget {
  @override
  _VmProviderState<T> createState() => _VmProviderState<T>();

  final T vm;
  final Widget Function(BuildContext context, T vm) builder;

  VmProvider({@required this.vm, @required this.builder});
}

class _VmProviderState<T extends ChangeNotifier> extends State<VmProvider<T>> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (_) => widget.vm,
      child: Consumer<T>(
        builder: (BuildContext context, T value, Widget child) {
          return widget.builder(context, value);
        },
      ),
    );
  }
}
