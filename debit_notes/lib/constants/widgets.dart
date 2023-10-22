import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyPageButtons extends StatelessWidget {
  const EmptyPageButtons(
      {super.key,
      required this.pageHeight,
      required this.pageWidth,
      required this.buttonText,
      this.function});

  final double? pageHeight;
  final double? pageWidth;
  final String? buttonText;
  final Function? function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function as void Function()?,
      child: Expanded(
        child: Container(
          height: 150,
          width: 165,
          decoration: decoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: pageHeight! / 50,
              ),
              content(),
              Text(
                buttonText!,
                style: GoogleFonts.spaceGrotesk(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
              SizedBox(
                height: pageHeight! / 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stack content() {
    return Stack(
      children: [
        Image.asset(
          "images/button_bg.png",
          fit: BoxFit.fill,
          width: 112,
          height: 92,
        ),
        Positioned(
            left: pageWidth! / 8.5,
            top: pageHeight! / 30,
            child: Icon(
              buttonText!.contains("Create")
                  ? FontAwesomeIcons.users
                  : FontAwesomeIcons.lock,
              color: Colors.white,
            )),
      ],
    );
  }

  BoxDecoration decoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(width: 2, color: Color.fromRGBO(206, 102, 255, 1)),
        color: Color.fromRGBO(236, 162, 255, 0.2));
  }
}
