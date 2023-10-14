import 'package:debit_notes/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

List debitAmount = [];
List debitDescription = [];
int debitAmountSum = 0;

class FirstCardPage extends StatefulWidget {
  const FirstCardPage({super.key});

  @override
  State<FirstCardPage> createState() => _FirstCardPageState();
}

class _FirstCardPageState extends State<FirstCardPage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void _showBottomSheet(BuildContext context) {
    var pageHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              height: pageHeight * 0.7,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: pageHeight * 0.03,
                    ),
                    amountTextField(),
                    SizedBox(
                      height: pageHeight * 0.03,
                    ),
                    descriptionTextField(),
                    Spacer(),
                    addPaymentButton(context),
                    SizedBox(
                      height: pageHeight * 0.03,
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  Container addPaymentButton(BuildContext context) {
    return Container(
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
          if (descriptionController.text != "" && amountController.text != "") {
            setState(() {
              debitAmount.add(amountController.text);
              debitDescription.add(descriptionController.text);
              debitAmountSum += int.parse(amountController.text);
              amountController.clear();
              descriptionController.clear();
            });
            Navigator.pop(context);
          }
        },
        child: Text(
          'Add Payment',
          style: GoogleFonts.prompt(
              color: Color(0xffFFFFFF),
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  TextFormField descriptionTextField() {
    return TextFormField(
      controller: descriptionController,
      style: GoogleFonts.spaceGrotesk(
          fontSize: 15, color: Color.fromRGBO(71, 84, 103, 0.7)),
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Color.fromRGBO(190, 193, 199, 1), width: 1),
              borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromRGBO(234, 236, 240, 1), width: 1),
              borderRadius: BorderRadius.circular(8)),
          hintText: "Description",
          hintStyle: GoogleFonts.manrope(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: const Color.fromRGBO(71, 84, 103, 0.7)),
          border: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromRGBO(234, 236, 240, 1), width: 0.5),
              borderRadius: BorderRadius.circular(8))),
    );
  }

  TextFormField amountTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: amountController,
      style: GoogleFonts.spaceGrotesk(
          fontSize: 15, color: Color.fromRGBO(71, 84, 103, 0.7)),
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Color.fromRGBO(190, 193, 199, 1), width: 1),
              borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromRGBO(234, 236, 240, 1), width: 1),
              borderRadius: BorderRadius.circular(8)),
          hintText: "Amount of Payment",
          hintStyle: GoogleFonts.manrope(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: const Color.fromRGBO(71, 84, 103, 0.7)),
          border: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromRGBO(234, 236, 240, 1), width: 0.5),
              borderRadius: BorderRadius.circular(8))),
    );
  }

  @override
  Widget build(BuildContext context) {
    var pageWidth = MediaQuery.of(context).size.width;
    var pageHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomSheet: openPaymentBottomSheet(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        toolbarHeight: 150,
        title: Text(
          "What\nBaki Paids",
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

  Padding openPaymentBottomSheet() {
    return Padding(
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
            _showBottomSheet(context);
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
        itemCount: debitAmount.length,
        itemBuilder: (context, index) {
          final item = debitAmount[index];
          return Dismissible(
            key: Key(item),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                debitAmount.removeAt(index);
                debitDescription.removeAt(index);
                debitAmountSum -= int.parse(item);
              });
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("$item dismissed")));
            },
            background: SizedBox(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color.fromARGB(255, 255, 0, 0)),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            movementDuration: Duration(milliseconds: 500), // Kaydırma süresi
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                // Kırmızı alana dokunulduğunda onay kutusu gösterilir
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Onay"),
                      content: const Text(
                          "Bu öğeyi silmek istediğinizden emin misiniz?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Sil"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("İptal"),
                        ),
                      ],
                    );
                  },
                );
              }
              return false;
            },
            child: debitListCard(pageWidth, pageHeight, debitAmount[index],
                debitDescription[index]),
          );
        },
      ),
    );
  }

  Container debitListCard(
      double pageWidth, double pageHeight, String amount, String description) {
    return Container(
      width: pageWidth,
      height: pageHeight * 0.06,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color.fromARGB(255, 255, 255, 255)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              description,
              style:
                  GoogleFonts.prompt(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              amount + " zł",
              style:
                  GoogleFonts.prompt(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

Container card1(double pageWidth, double pageHeight) {
  return Container(
    width: pageWidth,
    height: pageHeight * 0.25,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), color: CardColors.red),
    child: Padding(
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
    ),
  );
}
