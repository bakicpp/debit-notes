import 'package:debit_notes/constants/colors.dart';
import 'package:debit_notes/pages/card_pages/first_card_page.dart';
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

  GestureDetector card1(double pageWidth, double pageHeight) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const FirstCardPage()), // İkinci ekranın adı "SecondScreen"
        );
      },
      child: Container(
        width: pageWidth,
        height: pageHeight * 0.25,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: CardColors.red),
        child: firstCardContent(),
      ),
    );
  }

  Padding firstCardContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Baki",
            style:
                GoogleFonts.prompt(fontSize: 36, fontWeight: FontWeight.w700),
          ),
          Text(
            debitAmountSum.toString() + "zł",
            style:
                GoogleFonts.prompt(fontSize: 36, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
