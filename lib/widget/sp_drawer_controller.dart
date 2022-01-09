import 'package:flutter/material.dart';
import 'package:sp_delivery/constant/constant.dart';
import 'package:sp_delivery/model/drawer_model.dart';
import 'package:sp_delivery/widget/drawer.dart';

class SpDrawerController extends StatefulWidget {
  const SpDrawerController({
    Key? key,
    this.drawerWidth = 250,
    required this.onDrawerCall,
    this.screenView,
    required this.animationController,
    this.animatedIconData = AnimatedIcons.arrow_menu,
    this.menuView,
    this.drawerIsOpen,
    required this.screenIndex,
  }) : super(key: key);

  final double drawerWidth;
  final Function(DrawerIndex) onDrawerCall;
  final Widget? screenView;
  final Function(AnimationController) animationController;
  final Function(bool)? drawerIsOpen;
  final AnimatedIconData animatedIconData;
  final Widget? menuView;
  final DrawerIndex screenIndex;

  @override
  _DrawerUserControllerState createState() => _DrawerUserControllerState();
}

class _DrawerUserControllerState extends State<SpDrawerController>
    with TickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController iconAnimationController;
  late AnimationController animationController;

  double scrolloffset = 0.0;
  bool isSetDawer = false;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    iconAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 0));

    iconAnimationController.animateTo(1.0,
        duration: const Duration(milliseconds: 0), curve: Curves.fastOutSlowIn);

    scrollController =
        ScrollController(initialScrollOffset: widget.drawerWidth);

    scrollController.addListener(() {
      if (scrollController.offset <= 0) {
        if (scrolloffset != 1.0) {
          setState(() {
            scrolloffset = 1.0;
            try {
              widget.drawerIsOpen!(true);
            } catch (_) {}
          });
        }

        iconAnimationController.animateTo(0.0,
            duration: const Duration(milliseconds: 0), curve: Curves.linear);
      } else if (scrollController.offset > 0 &&
          scrollController.offset < widget.drawerWidth) {
        iconAnimationController.animateTo(
            (scrollController.offset * 100 / (widget.drawerWidth)) / 100,
            duration: const Duration(milliseconds: 0),
            curve: Curves.linear);
      } else if (scrollController.offset <= widget.drawerWidth) {
        if (scrolloffset != 0.0) {
          setState(() {
            scrolloffset = 0.0;
            try {
              widget.drawerIsOpen!(false);
            } catch (_) {}
          });
        }

        iconAnimationController.animateTo(1.0,
            duration: const Duration(milliseconds: 0), curve: Curves.linear);
      }
    });

    getInitState();

    super.initState();
  }

  Future<bool> getInitState() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 300));
    try {
      widget.animationController(iconAnimationController);
    } catch (_) {}

    await Future<dynamic>.delayed(const Duration(milliseconds: 100));
    scrollController.jumpTo(
      widget.drawerWidth,
    );

    setState(() {
      isSetDawer = true;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(parent: ClampingScrollPhysics()),
        child: Opacity(
          opacity: isSetDawer ? 1 : 0,
          child: SizedBox(
            height: height,
            width: width + widget.drawerWidth,
            child: Container(
              color: Colors.white54,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: widget.drawerWidth,
                    height: height,
                    child: AnimatedBuilder(
                      animation: iconAnimationController,
                      builder: (BuildContext context, Widget? child) {
                        return Transform(
                          transform: Matrix4.translationValues(
                              scrollController.offset, 0.0, 0.0),
                          child: SizedBox(
                            height: height,
                            width: widget.drawerWidth,
                            child: SpDrawer(
                              screenIndex: widget.screenIndex,
                              iconAnimationController: iconAnimationController,
                              callBackIndex: (DrawerIndex indexType) {
                                onDrawerClick();
                                try {
                                  widget.onDrawerCall(indexType);
                                  // ignore: empty_catches
                                } catch (e) {}
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: width,
                    height: height,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.indigo.withOpacity(0.2),
                              blurRadius: 24),
                        ],
                      ),
                      child: Stack(
                        children: <Widget>[
                          IgnorePointer(
                            ignoring: scrolloffset == 1 || false,
                            child: widget.screenView ??
                                Container(
                                  color: Colors.white,
                                ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).padding.top + 8,
                                    left: 8),
                                child: SizedBox(
                                  width: AppBar().preferredSize.height - 8,
                                  height: AppBar().preferredSize.height - 8,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(
                                          AppBar().preferredSize.height),
                                      child: Center(
                                        child: widget.menuView ??
                                            AnimatedIcon(
                                                icon: widget.animatedIconData,
                                                progress:
                                                    iconAnimationController),
                                      ),
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        onDrawerClick();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).padding.top +
                                          8,
                                      left: width / 4.2),
                                  child: Text(
                                    'SP Delivery',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Trajan Pro'),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onDrawerClick() {
    if (scrollController.offset != 0.0) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      scrollController.animateTo(
        widget.drawerWidth,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    }
  }
}
