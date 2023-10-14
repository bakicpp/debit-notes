import 'package:debit_notes/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstCardPage extends StatefulWidget {
  const FirstCardPage({super.key});

  @override
  State<FirstCardPage> createState() => _FirstCardPageState();
}

class _FirstCardPageState extends State<FirstCardPage> {
  @override
  Widget build(BuildContext context) {
    var pageWidth = MediaQuery.of(context).size.width;
    var pageHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Container(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xff41C23F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // Add your button's functionality here
            },
            child: Text(
              'Add Payment',
              style: GoogleFonts.prompt(
                  color: Color(0xffFFFFFF),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 150,
        title: Text(
          "What\n ... Paids",
          style: GoogleFonts.prompt(fontSize: 48, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              card1(pageWidth, pageHeight),
              SizedBox(
                height: pageHeight * 0.05,
              ),
              debitListBackground(pageWidth, pageHeight),
            ],
          ),
        ),
      ),
    );
  }

  Container debitListBackground(double pageWidth, double pageHeight) {
    return Container(
      width: pageWidth,
      height: pageHeight * 0.5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Color(0xffE9E9E9)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(
              height: pageHeight * 0.03,
            ),
            debitList(pageHeight, pageWidth),
          ],
        ),
      ),
    );
  }

  SizedBox debitList(double pageHeight, double pageWidth) {
    return SizedBox(
      height: pageHeight * 0.43,
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return debitListCard(pageWidth, pageHeight);
        },
      ),
    );
  }

  Container debitListCard(double pageWidth, double pageHeight) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      width: pageWidth,
      height: pageHeight * 0.06,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color.fromARGB(255, 255, 255, 255)),
    );
  }
}

Container card1(double pageWidth, double pageHeight) {
  return Container(
    width: pageWidth,
    height: pageHeight * 0.25,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), color: CardColors.red),
  );
}
