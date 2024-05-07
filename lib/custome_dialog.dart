import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final String title;
  final String content;
  final IconData? icon;
  final Color? iconColor;

  CustomDialog({
    required this.title,
    required this.content,
    this.icon,
    this.iconColor,
    Key? key, // Add key parameter
  }) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _scaleAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var titleFontSize = screenWidth * 0.02;
    var contentFontSize = screenWidth * 0.017;
    var buttonFontSize = screenWidth * 0.015;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        key: widget.key, // Assign key to Dialog
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: SizedBox(
          width: screenWidth * 0.5,
          child: dialogContent(
            context,
            titleFontSize,
            contentFontSize,
            buttonFontSize,
          ),
        ),
      ),
    );
  }

  Widget dialogContent(BuildContext context, double titleFontSize,
      double contentFontSize, double buttonFontSize) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            widget.content,
            style: TextStyle(
              fontSize: contentFontSize,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.02),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                _animationController.reverse();
                _animationController.addStatusListener((status) {
                  if (status == AnimationStatus.dismissed) {
                    Navigator.of(context).pop();
                  }
                });
              },
              child: Text(
                'Close',
                style: TextStyle(
                  fontSize: buttonFontSize,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
