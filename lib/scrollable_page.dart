import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScrollablePage extends StatefulWidget {
  @override
  _ScrollablePageState createState() => _ScrollablePageState();
}

class _ScrollablePageState extends State<ScrollablePage> {
  ItemScrollController itemScrollController;
  ItemPositionsListener itemPositionsListener;
  bool isShrink = false;
  @override
  void initState() {
    itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();

    itemPositionsListener.itemPositions.addListener(() {
      isShrink = itemPositionsListener.itemPositions.value.first.index != 0;

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            appBar,
            tabs,
            _list,
          ],
        ),
      ),
    );
  }

  Widget get appBar => AnimatedContainer(
        color: Colors.blue.shade50,
        height: isShrink ? kToolbarHeight : 300,
        width: ScreenUtil().screenWidth,
        duration: Duration(
          milliseconds: 300,
        ),
        child: isShrink
            ? Center(
                child: Text('Shrink'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, color: Colors.green.shade400),
                  Text("its Expanded"),
                ],
              ),
      );

  Widget get tabs => Container(
        height: 100,
        color: Colors.red,
        width: ScreenUtil().screenWidth,
        child: Center(
          child: ListView.builder(
            itemCount: 4,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) => InkWell(
              onTap: () => jumpTo(i),
              child: Container(
                width: 100,
                color: itemPositionsListener.itemPositions.value.first.index ==
                            i ||
                        itemPositionsListener.itemPositions.value.first.index ==
                                0 &&
                            itemPositionsListener
                                    .itemPositions.value.first.index ==
                                1
                    ? Colors.yellow.shade100
                    : Colors.green.shade100,
                child: Center(child: Text('\t${i + 1}\t')),
              ),
            ),
          ),
        ),
      );
  Widget get _list => Expanded(
        child: ScrollablePositionedList.builder(
          // physics: NeverScrollableScrollPhysics(),
          itemCount: 5,
          initialScrollIndex: 0,
          itemBuilder: (context, index) => index == 0
              ? SizedBox(height: 5)
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 25,
                  itemBuilder: (_, i) => Text('$index - $i')),
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
        ),
      );

  void jumpTo(index) {
    itemScrollController.scrollTo(
        index: index,
        duration: Duration(seconds: 2),
        curve: Curves.easeInOutCubic);
  }
}
