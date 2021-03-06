import 'package:flutter/material.dart';

class ViewAllScreen extends StatelessWidget {
  final String title;
  final Widget Function(List list, int index) listItem;
  final bool isGrid;
  final Stream stream;
  final List list;
  ViewAllScreen({this.title, this.listItem, this.isGrid = false, this.stream, this.list});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _appbarBuilder(context),
                _textBuilder(),
                SizedBox(
                  height: 20.0,
                ),
                isGrid ? _gridBuilder() : _listBuilder(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appbarBuilder(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _textBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22.0,
        ),
      ),
    );
  }

  Widget _listBuilder() {
    return StreamBuilder(
      stream: stream,
      builder: (context, snap) {
        if (snap.hasData) {
          final _list = snap.data;
          return ListView.builder(
            itemCount: _list.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return listItem(_list, index);
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _gridBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
        ),
        itemBuilder: (context, index) {
          return listItem([], index);
        },
      ),
    );
  }
}
