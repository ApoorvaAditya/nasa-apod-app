import 'package:flutter/material.dart';

class CreationAwareWidget extends StatefulWidget {
  final VoidCallback itemCreated;
  final Widget child;

  const CreationAwareWidget({
    super.key,
    required this.itemCreated,
    required this.child,
  });

  @override
  _CreationAwareWidgetState createState() => _CreationAwareWidgetState();
}

class _CreationAwareWidgetState extends State<CreationAwareWidget> {
  @override
  void initState() {
    super.initState();
    widget.itemCreated();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
