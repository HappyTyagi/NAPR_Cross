import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class IconToastWidget extends StatelessWidget {
  final Key? key;
  final Color? backgroundColor;
  final String? message;
  final Widget? textWidget;
  final double? height;
  final double? width;
  final String? assetName;
  final EdgeInsetsGeometry? padding;

  IconToastWidget({
    this.key,
    this.backgroundColor,
    this.textWidget,
    this.message,
    this.height,
    this.width,
    @required this.assetName,
    this.padding,
  }) : super(key: key);

  factory IconToastWidget.fail({String? msg}) => IconToastWidget(
    message: msg,
    assetName: 'assets/images/ic_error.png',
  );

  factory IconToastWidget.success({String? msg}) => IconToastWidget(
    message: msg,
    assetName: 'assets/images/icon-success.png',


  );

  @override
  Widget build(BuildContext context) {
    Widget content = Material(
      color: Colors.transparent,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50.0),
          padding:
          padding ?? EdgeInsets.symmetric(vertical: 20.0, horizontal: 17.0),
          decoration: ShapeDecoration(
            color: backgroundColor ??  Color(0xFF97144D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Image.asset(
                  assetName!,
                  fit: BoxFit.cover,
                  color: Colors.white,
                  width: 30,
                  height: 30,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: textWidget ??
                    Text(
                      message ?? '',
                      style: TextStyle(
                          fontSize:
                          Theme.of(context).textTheme.titleLarge!.fontSize,
                          color: Colors.white),
                      softWrap: true,
                      maxLines: 200,
                    ),
              ),
            ],
          )),
    );

    return content;
  }
}

class BannerToastWidget extends StatelessWidget {
  final Key? key;
  final Color? backgroundColor;
  final String? message;
  final Widget? textWidget;
  final double? offset;
  final double? height;
  final double? width;

  BannerToastWidget(
      {this.key,
        this.backgroundColor,
        this.textWidget,
        this.message,
        this.height,
        this.width,
        double? offset})
      : this.offset = (offset == null ? 10.0 : offset),
        super(key: key);

  factory BannerToastWidget.success(
      {String? msg, Widget? text, BuildContext? context}) =>
      BannerToastWidget(
        backgroundColor: context != null
            ? Theme.of(context).hintColor
            : Colors.green,
        message: msg,
        textWidget: text,
      );

  factory BannerToastWidget.fail(
      {String? msg, Widget? text, BuildContext? context}) =>
      BannerToastWidget(
        backgroundColor: context != null
            ? Theme.of(context).hintColor
            : const Color(0xEFCC2E2E),
        message: msg,
        textWidget: text,
      );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget content = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(17.0),
      height: 60.0,
      alignment: Alignment.center,
      color: backgroundColor ?? Theme.of(context).hintColor,
      child: textWidget ??
          Text(
            message ?? '',
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                color: Colors.white),
          ),
    );

    return content;
  }
}

class ActionToastWidget extends StatelessWidget {
  final String? text;
  final Widget? textWidget;
  final Widget? actionWidget;

  const ActionToastWidget({
    this.text,
    this.textWidget,
    this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      margin: EdgeInsets.symmetric(horizontal: 50.0),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: Colors.green[600],
          shadows: [
            const BoxShadow(
              offset: Offset.zero,
              spreadRadius: 10,
              blurRadius: 10,
              color: const Color(0x040D0229),
            ),
          ]),
      child: Row(
        children: [
          textWidget ??
              Text(
                text ?? '',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
          actionWidget ??
              IconButton(
                onPressed: () {
                  dismissAllToast(showAnim: true);
                },
                icon: Icon(
                  Icons.add_circle_outline_outlined,
                  color: Colors.white,
                ),
              ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}