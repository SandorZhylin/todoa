import 'dart:ui';

import 'package:flutter/material.dart';

class ItemData extends StatefulWidget {
  final bool isChecked;
  final String title;
  final Function onCheckedChanges;
  final Function onLongPressed;

  ItemData({
    this.isChecked = false,
    required this.title,
    required this.onCheckedChanges,
    required this.onLongPressed,
  });

  @override
  _ItemDataState createState() => _ItemDataState();
}

class _ItemDataState extends State<ItemData>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween(begin: 0.0, end: 10.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_controller)
          ..addStatusListener(
            (status) {
              if (status == AnimationStatus.completed) {
                _controller.reverse();
              }
            },
          );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(seconds: 1),
              pageBuilder: (_, __, ___) => DetailedItem(tag: widget.title),
            ),
          );
        },
        onLongPress: () {
          widget.onLongPressed();
        },
        child: Row(
          children: [
            Checkbox(
              value: widget.isChecked,
              activeColor: widget.isChecked ? Colors.grey : Colors.black,
              onChanged: (bool? value) {
                print('$value');

                _controller.forward(from: 0.0);
                widget.onCheckedChanges(value);
              },
            ),
            Expanded(
              child: AnimatedBuilder(
                builder: (BuildContext context, Widget? child) {
                  return Container(
                    padding: EdgeInsets.only(
                      left: _animation.value + 10.0,
                      right: 10.0 - _animation.value,
                    ),
                    child: Hero(
                      tag: widget.title,
                      child: Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 24,
                          color: widget.isChecked ? Colors.grey : Colors.black,
                          decoration: widget.isChecked
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  );
                },
                animation: _animation,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailedItem extends StatelessWidget {
  final String tag;

  const DetailedItem({this.tag = 'title'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detailed screen"),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          child: Center(
            child: Hero(
              tag: tag,
              child: Text(
                tag,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
