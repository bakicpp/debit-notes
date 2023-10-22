import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debit_notes/constants/colors.dart';
import 'package:debit_notes/constants/vectors.dart';
import 'package:debit_notes/constants/widgets.dart';
import 'package:debit_notes/pages/card_pages/first_card_page.dart';
import 'package:debit_notes/pages/card_pages/second_card_page.dart';
import 'package:debit_notes/pages/card_pages/third_card_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int yourPayment = 0;

  bool testMode = true;

  @override
  Widget build(BuildContext context) {
    var pageWidth = MediaQuery.of(context).size.width;
    var pageHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Debit's",
            style:
                GoogleFonts.prompt(fontSize: 48, fontWeight: FontWeight.w700),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: pageWidth / 18),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: testMode
                ? noGroupView(pageHeight, pageWidth)
                : Column(
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

  Column noGroupView(double pageHeight, double pageWidth) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: pageHeight / 8,
          ),
          Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: Vectors.emptyState,
            ),
          ),
          Text("You don't have an group yet."),
          SizedBox(
            height: pageHeight / 20,
          ),
          buttonsRow(pageHeight, pageWidth)
        ]);
  }

  Row buttonsRow(double pageHeight, double pageWidth) {
    return Row(
      children: [
        EmptyPageButtons(
            pageHeight: pageHeight,
            pageWidth: pageWidth,
            buttonText: "Create Group"),
        SizedBox(
          width: pageWidth / 28,
        ),
        EmptyPageButtons(
            pageHeight: pageHeight,
            pageWidth: pageWidth,
            buttonText: "Join Group")
      ],
    );
  }

  GestureDetector card3(double pageWidth, double pageHeight) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child:
                  const ThirdCardPage()), // İkinci ekranın adı "SecondScreen"
        );
      },
      child: Container(
        width: pageWidth,
        height: pageHeight * 0.25,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4), // changes position of shadow
          ),
        ], borderRadius: BorderRadius.circular(16), color: CardColors.green),
        child: Container(
          width: pageWidth,
          height: pageHeight * 0.25,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), color: CardColors.pink),
          child: cardContent("ibrahim", "İbrahim"),
        ),
      ),
    );
  }

  GestureDetector card2(double pageWidth, double pageHeight) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child:
                  const SecondCardPage()), // İkinci ekranın adı "SecondScreen"
        );
      },
      child: Container(
        width: pageWidth,
        height: pageHeight * 0.25,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4), // changes position of shadow
          ),
        ], borderRadius: BorderRadius.circular(16), color: CardColors.pink),
        child: Container(
          width: pageWidth,
          height: pageHeight * 0.25,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), color: CardColors.green),
          child: cardContent("anil", "Anıl"),
        ),
      ),
    );
  }

  GestureDetector card1(double pageWidth, double pageHeight) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child:
                  const FirstCardPage()), // İkinci ekranın adı "SecondScreen"
        );
      },
      child: Container(
        width: pageWidth,
        height: pageHeight * 0.25,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4), // changes position of shadow
          ),
        ], borderRadius: BorderRadius.circular(16), color: CardColors.red),
        child: cardContent("baki", "Baki"),
      ),
    );
  }

  Padding cardContent(String username, String userShownName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userShownName,
            style:
                GoogleFonts.prompt(fontSize: 36, fontWeight: FontWeight.w700),
          ),
          realTimeAmount(username, userShownName),
        ],
      ),
    );
  }

  StreamBuilder<DocumentSnapshot<Object?>> realTimeAmount(
      String username, String userShownName) {
    late CollectionReference _ref =
        FirebaseFirestore.instance.collection("users/$username/amounts");

    return StreamBuilder<DocumentSnapshot>(
        stream: _ref.doc("debitSum").snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return calculatedAmount(data, userShownName);
        });
  }

  Column calculatedAmount(Map<String, dynamic> data, String userShownName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data["debitAmountSum"].toString() + "zł",
          style: GoogleFonts.prompt(fontSize: 36, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 24.0,
        ),
        int.parse(data["debitAmountSum"]) != 0
            ? Text(
                "You must pay to " +
                    userShownName +
                    " " +
                    (int.parse(data["debitAmountSum"]) / 3).toStringAsFixed(2) +
                    "zł",
                style: GoogleFonts.prompt(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor),
              )
            : Container()
      ],
    );
  }
}
