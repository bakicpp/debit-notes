import 'package:debit_notes/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var pageWidth = MediaQuery.of(context).size.width;
    var pageHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        bottomSheet: Container(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xff41C23F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              // Add your button's functionality here
            },
            child: Text('Button'),
          ),
        ),
        appBar: AppBar(
          title: Text(
            "Debit\'s",
            style:
                GoogleFonts.prompt(fontSize: 48, fontWeight: FontWeight.w700),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: pageHeight * 0.05,
                ),
                card1(pageWidth, pageHeight),
                SizedBox(
                  height: pageHeight * 0.05,
                ),
                card2(pageWidth, pageHeight),
                SizedBox(
                  height: pageHeight * 0.05,
                ),
                card3(pageWidth, pageHeight),
              ],
            ),
          ),
        ));
  }

  Container card3(double pageWidth, double pageHeight) {
    return Container(
      width: pageWidth,
      height: pageHeight * 0.25,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: CardColors.green),
    );
  }

  Container card2(double pageWidth, double pageHeight) {
    return Container(
      width: pageWidth,
      height: pageHeight * 0.25,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: CardColors.pink),
    );
  }

  Container card1(double pageWidth, double pageHeight) {
    return Container(
      width: pageWidth,
      height: pageHeight * 0.25,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: CardColors.red),
    );
  }
}
