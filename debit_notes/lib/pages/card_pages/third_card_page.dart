import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debit_notes/constants/colors.dart';
import 'package:debit_notes/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

int debitAmountSum = 0;

class ThirdCardPage extends StatefulWidget {
  const ThirdCardPage({super.key});

  @override
  State<ThirdCardPage> createState() => _ThirdCardPageState();
}

class _ThirdCardPageState extends State<ThirdCardPage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    firebaseCollectionService.getById("debitSum").then((value) {
      setState(() {
        debitAmountSum = int.parse(value["debitAmountSum"]);
      });
    });
    // TODO: implement initState
    super.initState();
  }

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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    const Spacer(),
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

  FirebaseCollectionService firebaseCollectionService =
      FirebaseCollectionService('users/ibrahim/amounts');

  void updateDebitSum() {
    firebaseCollectionService.update("debitSum", {
      'debitAmountSum': debitAmountSum.toString(),
    });
  }

  void addPayment() {
    if (descriptionController.text != "" && amountController.text != "") {
      setState(() {
        debitAmountSum += int.parse(amountController.text);
        updateDebitSum();
        firebaseCollectionService.add({
          'amount': amountController.text,
          'description': descriptionController.text,
          'timeStamp': DateTime.now().toString(),
        });
        amountController.clear();
        descriptionController.clear();
      });
      Navigator.pop(context);
    }
  }

  Container addPaymentButton(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: const Color(0xff41C23F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: addPayment,
        child: Text(
          'Add Payment',
          style: GoogleFonts.prompt(
              color: const Color(0xffFFFFFF),
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
          fontSize: 15, color: const Color.fromRGBO(71, 84, 103, 0.7)),
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromRGBO(190, 193, 199, 1), width: 1),
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
          fontSize: 15, color: const Color.fromRGBO(71, 84, 103, 0.7)),
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromRGBO(190, 193, 199, 1), width: 1),
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
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        toolbarHeight: 150,
        title: Text(
          "What\nİbrahim Paids",
          style: GoogleFonts.prompt(fontSize: 48, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              card2(pageWidth, pageHeight),
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
            primary: const Color(0xff41C23F),
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
                color: const Color(0xffFFFFFF),
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
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xffE9E9E9)),
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

  void deleteItem(int index, var item, List snap) async {
    setState(() {
      firebaseCollectionService.delete(item);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("$item dismissed")));
    setState(() {
      debitAmountSum =
          debitAmountSum - int.parse(snap[index]["amount"] as String);
      updateDebitSum();
    });
    print("sum: $debitAmountSum");
  }

  late CollectionReference _ref =
      FirebaseFirestore.instance.collection("users/ibrahim/amounts");

  StreamBuilder debitList(double pageHeight, double pageWidth) {
    return StreamBuilder<QuerySnapshot>(
        stream: _ref.orderBy("timeStamp").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          try {
            final snap = snapshot.data!.docs;
            if (snapshot.hasData) {
              if (snap.isEmpty) {
                return listEmptyState(pageWidth);
              }
            }
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            return SizedBox(
              height: pageHeight * 0.43,
              child: ListView.builder(
                itemCount: snap.length,
                itemBuilder: (context, index) {
                  String documentId = snap.toList()[index].id;

                  return scrollToLeftWidget(
                      documentId, index, context, pageWidth, pageHeight, snap);
                },
              ),
            );
          } catch (e) {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Column listEmptyState(double pageWidth) {
    return Column(
      children: [
        Vectors.emptyState,
        Text(
          "No item added yet.",
          style: GoogleFonts.manrope(
              fontSize: pageWidth / 25,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(105, 105, 105, 1)),
        ),
      ],
    );
  }

  Dismissible scrollToLeftWidget(
      String documentId,
      int index,
      BuildContext context,
      double pageWidth,
      double pageHeight,
      List<QueryDocumentSnapshot<Object?>> snap) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        deleteItem(index, documentId, snap);
      },
      background: SizedBox(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 255, 0, 0)),
          child: const Align(
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
      movementDuration: const Duration(milliseconds: 500),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Onay"),
                content:
                    const Text("Bu öğeyi silmek istediğinizden emin misiniz?"),
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
      child: debitListCard(pageWidth, pageHeight, snap[index]["amount"],
          snap[index]["description"]),
    );
  }

  Container debitListCard(
      double pageWidth, double pageHeight, var amount, var description) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: pageWidth,
      height: pageHeight * 0.06,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(255, 255, 255, 255)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$description",
              style:
                  GoogleFonts.prompt(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              "$amount zł",
              style:
                  GoogleFonts.prompt(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

Container card2(double pageWidth, double pageHeight) {
  return Container(
    width: pageWidth,
    height: pageHeight * 0.25,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), color: CardColors.pink),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "İbrahim",
            style:
                GoogleFonts.prompt(fontSize: 36, fontWeight: FontWeight.w700),
          ),
          Text(
            "${debitAmountSum}zł",
            style:
                GoogleFonts.prompt(fontSize: 36, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    ),
  );
}
