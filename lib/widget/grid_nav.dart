import 'package:flutter/material.dart';
import 'package:flutter_trip/models/index.dart';
import 'package:flutter_trip/widget/webview.dart';

class GridNav extends StatelessWidget {
  final GridNavModel gridNavModel;

  const GridNav({Key key, @required this.gridNavModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: _gridNavItems(context),
      ),
    );
  }

  List<Widget> _gridNavItems(BuildContext context) {
    List<Widget> items = [];
    if (null == gridNavModel) return items;
    if (null != gridNavModel.hotel) {
      items.add(_gridNavItem(context, gridNavModel.hotel, true));
    }
    if (null != gridNavModel.flight) {
      items.add(_gridNavItem(context, gridNavModel.flight, false));
    }
    if (null != gridNavModel.travel) {
      items.add(_gridNavItem(context, gridNavModel.travel, false));
    }
    return items;
  }

  _gridNavItem(BuildContext context, GridNavItem gridNavItem, bool first) {
    List<Widget> items = [];
    items.add(_mainItem(context, gridNavItem.mainItem));
    items.add(_doubleItem(context, gridNavItem.item1, gridNavItem.item2));
    items.add(_doubleItem(context, gridNavItem.item3, gridNavItem.item4));
    List<Widget> expandItems = items
        .map(
          (e) => Expanded(
            child: e,
            flex: 1,
          ),
        )
        .toList();
    Color startColor = Color(int.parse('0xff' + gridNavItem.startColor));
    Color endColor = Color(int.parse('0xff' + gridNavItem.endColor));
    return Container(
      height: 88.0,
      margin: first ? null : EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [startColor, endColor]),
      ),
      child: Row(
        children: expandItems,
      ),
    );
  }

  Widget _mainItem(BuildContext context, CommonModel model) {
    return _warpGesture(
      context,
      Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Image.network(
            model.icon,
            fit: BoxFit.contain,
            height: 88,
            width: 120,
            alignment: AlignmentDirectional.bottomEnd,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              model.title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      model,
    );
  }

  Widget _doubleItem(
      BuildContext context, CommonModel topItem, CommonModel bottomItem) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _item(context, topItem, true),
        ),
        Expanded(
          child: _item(context, bottomItem, false),
        ),
      ],
    );
  }

  Widget _item(BuildContext context, CommonModel model, bool first) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: borderSide,
            bottom: first ? borderSide : BorderSide.none,
          ),
        ),
        child: _warpGesture(
          context,
          Center(
            child: Text(
              model.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          model,
        ),
      ),
    );
  }

  Widget _warpGesture(BuildContext context, Widget widget, CommonModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebView(
              url: model.url,
              statusBarColor: model.statusBarColor,
              hideAppBar: model.hideAppBar,
              title: model.title,
            ),
          ),
        );
      },
      child: widget,
    );
  }
}
