import 'package:flutter/material.dart';

class CreationAwareWidget extends StatefulWidget {
  final Function itemCreated;
  final Widget child;
  const CreationAwareWidget({
    Key key,
    this.itemCreated,
    this.child,
  }) : super(key: key);
  @override
  _CreationAwareWidgetState createState() => _CreationAwareWidgetState();
}

class _CreationAwareWidgetState extends State<CreationAwareWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.itemCreated != null) {
      widget.itemCreated();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}