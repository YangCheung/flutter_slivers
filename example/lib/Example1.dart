import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Example1 extends StatefulWidget {
  @override
  _Example1State createState() => new _Example1State();
}

class _Example1State extends State<Example1> {
//  RefreshMode  refreshing = RefreshMode.idle;
//  LoadMode loading = LoadMode.idle;
  RefreshController _refreshController;
  List<Widget> data = [];
  void _getDatas() {
    for (int i = 0; i < 14; i++) {
      data.add(new Card(
        margin:
            new EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
        child: new Center(
          child: new Text('Data $i'),
        ),
      ));
    }
  }

  void enterRefresh() {
    _refreshController.requestRefresh(true);
  }

  void _onOffsetCallback(bool isUp, double offset) {
    // if you want change some widgets state ,you should rewrite the callback
  }

  @override
  void initState() {
    // TODO: implement initState
    _getDatas();
    _refreshController = new RefreshController();
    super.initState();
  }

  Widget _headerCreate(BuildContext context, int mode) {
    return new ClassicIndicator(
      mode: mode,
      refreshingText: "",
      idleIcon: new Container(),
      idleText: "Load more...",
    );
  }

//  Widget _footerCreate(BuildContext context,int mode){
//    return new ClassicIndicator(mode: mode);
//  }

  Widget _buildBody() {
    List<String> _tabs = ["123", "414", "213"];

    return
       DefaultTabController(
            length: _tabs.length, // This is the number of tabs.
            child:
    NestedScrollView(
        physics: BouncingScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                // These are the slivers that show up in the "outer" scroll view.
                return <Widget>[
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    child:
                    SliverPersistentHeader(
                      delegate: _SliverTopDelegate(
                          Container(
//                             height: 200,
//                             width: double.infinity,
                            color: Colors.pinkAccent,
                            child: Text("124124"),
                          )
                      ),
                      pinned: true,
                    ),
                  ),

                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        labelColor: Colors.black87,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(icon: Icon(Icons.info), text: "Tab 1"),
                          Tab(icon: Icon(Icons.lightbulb_outline), text: "Tab 2"),
                        ],
                      ),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                // These are the contents of the tab views, below the tabs.
                children: _tabs.map((String name) {
                  return SafeArea(
                    top: false,
                    bottom: false,
                    child: Builder(
                      // This Builder is needed to provide a BuildContext that is "inside"
                      // the NestedScrollView, so that sliverOverlapAbsorberHandleFor() can
                      // find the NestedScrollView.
                      builder: (BuildContext context) {
                        return CustomScrollView(
                          // The "controller" and "primary" members should be left
                          // unset, so that the NestedScrollView can control this
                          // inner scroll view.
                          // If the "controller" property is set, then this scroll
                          // view will not be associated with the NestedScrollView.
                          // The PageStorageKey should be unique to this ScrollView;
                          // it allows the list to remember its scroll position when
                          // the tab view is not on the screen.
                          key: PageStorageKey<String>(name),
                          slivers: <Widget>[
                            SliverOverlapInjector(
                              // This is the flip side of the SliverOverlapAbsorber above.
                              handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.all(8.0),
                              // In this example, the inner scroll view has
                              // fixed-height list items, hence the use of
                              // SliverFixedExtentList. However, one could use any
                              // sliver widget here, e.g. SliverList or SliverGrid.
                              sliver: SliverFixedExtentList(
                                // The items in this example are fixed to 48 pixels
                                // high. This matches the Material Design spec for
                                // ListTile widgets.
                                itemExtent: 48.0,
                                delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                    // This builder is called for each child.
                                    // In this example, we just number each list item.
                                    return ListTile(
                                      title: Text('Item $index'),
                                    );
                                  },
                                  // The childCount of the SliverChildBuilderDelegate
                                  // specifies how many children this inner list
                                  // has. In this example, each tab has a list of
                                  // exactly 30 items, but this is arbitrary.
                                  childCount: 30,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            )
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: (){},
        child: _buildBody(),
    );
//    return new Container(
//        child:
////        DefaultTabController(
////          length: 3,
//             SmartRefresher(
//            enablePullDown: true,
//            enablePullUp: true,
//            controller: _refreshController,
//            onRefresh: (up) {
//              if (up)
//                new Future.delayed(const Duration(milliseconds: 2009))
//                    .then((val) {
//                  data.add(new Card(
//                    margin: new EdgeInsets.only(
//                        left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
//                    child: new Center(
//                      child: new Text('Data '),
//                    ),
//                  ));
//
//                  _refreshController.scrollTo(_refreshController.scrollController.offset+100.0);
//                  _refreshController.sendBack(true, RefreshStatus.idle);
//                  setState(() {});
////                refresher.sendStatus(RefreshStatus.completed);
//                });
//              else {
//                new Future.delayed(const Duration(milliseconds: 2009))
//                    .then((val) {
//                  data.add(new Card(
//                    margin: new EdgeInsets.only(
//                        left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
//                    child: new Center(
//                      child: new Text('Data '),
//                    ),
//                  ));
//                  setState(() {});
//                  _refreshController.sendBack(false, RefreshStatus.idle);
//                });
//              }
//            },
//            onOffsetChange: _onOffsetCallback,
//            child:_buildBody())
////        )
//    );
//            new ListView.builder(
//              reverse: true,
//              itemExtent: 100.0,
//              itemCount: data.length,
//              itemBuilder: (context, index) => new Item(),
//            ))

  }
}

class Item extends StatefulWidget {
  @override
  _ItemState createState() => new _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return new Card(
      margin:
          new EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
      child: new Center(
        child: new Text('Data'),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("销毁");
    super.dispose();
  }
}


class _SliverTopDelegate extends SliverPersistentHeaderDelegate {
  _SliverTopDelegate(this._widget);

  final Widget _widget;

  @override
  double get minExtent => 0;

  @override
  double get maxExtent => 200;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {

//    print("shrinkOffset = $shrinkOffset");

    if(maxExtent - shrinkOffset > 0) {
      return ClipRect(child: Stack(
          children: <Widget>[
            Positioned(top: -shrinkOffset, child: _widget,)
          ]
      ));
    } else {
      return ClipRect();
    }

  }

  @override
  bool shouldRebuild(_SliverTopDelegate oldDelegate) {
    return true;
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}