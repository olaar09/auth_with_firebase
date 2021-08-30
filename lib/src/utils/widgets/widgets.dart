import 'package:auth_with_firebase/src/utils/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

loadingOnPress() {}

button(
  String text, {
  Color color = Colors.white,
  borderColor: Colors.white,
  textColor: Colors.black,
  double horizontal: 12.0,
  double vertical: 20,
  double fontSize: 18,
  bool loading = false,
  required void Function() onPressed,
}) {
  return Container(
    decoration: BoxDecoration(),
    child: ElevatedButton(
      onPressed: loading ? loadingOnPress : onPressed,
      child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: Text(
            '$text',
            style: TextStyle(fontSize: 18, color: textColor),
          )),
      style: ButtonStyle(
        backgroundColor: loading
            ? MaterialStateProperty.all(Colors.grey)
            : MaterialStateProperty.all(color),
        elevation: MaterialStateProperty.all(0),
        side: MaterialStateProperty.all(BorderSide(
          width: 1,
          color: loading ? Colors.grey : borderColor,
        )),
      ),
    ),
  );
}

primaryButton(
  String text, {
  required void Function() onPressed,
  bool loading = false,
  double vertical: 20,
  double fontSize: 16.0,
  double horizontal: 12.0,
  required BuildContext context,
}) {
  var cl = Colors.blue;
  return button(text,
      textColor: Colors.white,
      color: Theme.of(context).primaryColor,
      loading: loading,
      borderColor: cl,
      fontSize: fontSize,
      vertical: vertical,
      horizontal: horizontal,
      onPressed: onPressed);
}

Widget leadingBtn(BuildContext context) {
  return hasBack(context: context)
      ? IconButton(
          onPressed: () {
            navToBack(context: context, data: null);
          },
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
        )
      : Container();
}

void navOfAllPage({required context, required route}) {
  Navigator.pushNamedAndRemoveUntil(
      context, route, (Route<dynamic> route) => false);
}

void navToPage({required context, required route, required data}) {
  Navigator.pushNamed(context, route, arguments: data);
}

void navToBack({required context, required data}) {
  Navigator.pop(context, data);
}

bool hasBack({required context}) {
  return Navigator.canPop(context);
}

void navOfPage({required context, required route, required data}) {
  Navigator.pushReplacementNamed(context, route, arguments: data);
}

mTextField(String label,
    {required void onChanged(String d),
    isPassword: false,
    double fontSize = 16,
    double textBoxPadding = 16,
    hintText = '',
    TextEditingController? controller,
    String? error,
    keyboardType: TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label.length > 0 ? regularText('$label') : SizedBox(),
        TextInput(
            onChanged: onChanged,
            keyboardType: keyboardType,
            fontSize: fontSize,
            controller: controller,
            hintText: hintText,
            textBoxPadding: textBoxPadding,
            isPassword: isPassword),
        error == null || error.length < 1
            ? SizedBox()
            : regularErrorText('$error')
      ],
    ),
  );
}

Widget regularText(String text,
    {double size: 18,
    Color? color,
    double lineHeight: 2,
    int maxLines = 5,
    textAlign: TextAlign.left}) {
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: size,
        letterSpacing: .1,
        height: lineHeight,
        color: color == null ? Colors.grey : color),
  );
}

Widget regularErrorText(String text, {double size: 18}) {
  return regularText(text, size: 16, color: Colors.deepOrange[700]!);
}

Widget networkActivityIndicator({double radius = 14.0}) {
  return CupertinoActivityIndicator(
    radius: radius,
  );
}

Widget boldText(String text,
    {double size: 18,
    color,
    textAlign: TextAlign.start,
    fontWeight: FontWeight.bold}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      fontWeight: fontWeight,
      fontSize: size,
      color: color == null ? color : Colors.grey,
    ),
  );
}

ScaffoldFeatureController mSnackBar({@required context, @required message}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('$message'),
  ));
}
