import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class TonedTab extends StatefulWidget implements PreferredSizeWidget {
  const TonedTab({
    required Key key,
    this.selectedTabColor = Colors.black,
    this.unselectedTabColor = Colors.grey,
    required this.tabTitles,
    this.fontWeight = FontWeight.bold,
    this.fontSize = 36,
    this.titleFontWeight = FontWeight.bold,
    this.titleFontSize = 16,
    this.titleColor = Colors.white,
  }) : super(key: key);

  /// Background color of the Appbar and tab bar, default is [Colors.black]

  final Color selectedTabColor;

  final Color unselectedTabColor;

  /// Set the font weight of the tab options, default is [FontWeight.w200].
  final FontWeight fontWeight, titleFontWeight;

  /// List of all the tab names
  @required
  final List<String> tabTitles;

  /// Font size of the tab names, default is [36]
  @required
  final double fontSize;

  /// Set the pivot title

  /// Font size of the pivot title, default is [16]
  final double titleFontSize;

  /// Color of pivot title, default is [Colors.white]
  final Color titleColor;

  @override
  State<StatefulWidget> createState() => TonedTabState();

  @override
  Size get preferredSize => Size.fromHeight(fontSize * 1.5 + 42.5011);
}

class TonedTabState extends State<TonedTab> {
  final ItemScrollController itemScrollController = ItemScrollController();

  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  int highlightedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: widget.fontSize * 1.7,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: ScrollablePositionedList.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              itemBuilder: (BuildContext context, int index) {
                return (index != widget.tabTitles.length)
                    ? Padding(
                        padding: const EdgeInsets.only(right: 28),
                        child: Text(
                          widget.tabTitles[index],
                          style: TextStyle(
                            fontSize: widget.fontSize,
                            color: (highlightedIndex == index)
                                ? widget.selectedTabColor
                                : widget.unselectedTabColor,
                            fontWeight: (highlightedIndex == index)
                                ? widget.fontWeight
                                : FontWeight.w300,
                          ),
                        ),
                      )
                    : Container(
                        width: 50,
                      );
              },
              itemCount: widget.tabTitles.length + 1,
            ),
          ),
        ),
      ],
    );
  }

  /// Function to take care of page change, currently only an increment of a decrement by 1 is allowed
  handlePagechange(int currentPage) {
    if (currentPage > highlightedIndex) {
      increase();
    } else {
      decrease();
    }
  }

  increase() {
    if (highlightedIndex != widget.tabTitles.length - 1) {
      setState(() {
        itemScrollController.scrollTo(
            index: highlightedIndex + 1,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: const Duration(milliseconds: 600));
        highlightedIndex++;
      });
    }
  }

  decrease() {
    if (highlightedIndex != 0) {
      setState(() {
        itemScrollController.scrollTo(
            index: highlightedIndex - 1,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: const Duration(milliseconds: 600));
        highlightedIndex--;
      });
    }
  }
}

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Color textColor;
  final FontWeight fontWeight;
  final double fontSize;

  const CustomAppBar(
      {required Key key,
      required this.title,
      required this.textColor,
      required this.fontSize,
      required this.fontWeight})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.only(top: 16, left: 16),
        child: Text(
          widget.title,
          style: TextStyle(
              color: widget.textColor,
              fontWeight: widget.fontWeight,
              fontSize: widget.fontSize),
        ),
      ),
    );
  }
}
