//this page created for the test of one page static card page

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debit_notes/constants/colors.dart';
import 'package:debit_notes/constants/vectors.dart';
import 'package:debit_notes/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// global variables
int debitAmountSum = 0;

// these variables are used for seperate payment
int user1Debit = 0;
int user2Debit = 0;

// this variable is used for changing view of card
bool changeView = false;

class CardPage extends StatefulWidget {
  const CardPage(
      {super.key,
      required this.groupDocumentId,
      required this.groupName,
      required this.userRef,
      required this.memberList});

  final String groupDocumentId;
  final String groupName;
  final String userRef;
  final List memberList;

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  //local variables
  TextEditingController amountController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  TextEditingController user1SeperateDebitController = TextEditingController();

  TextEditingController user2SeperateDebitController = TextEditingController();

  TextEditingController selfSeperateDebitController = TextEditingController();

  final flipCardController = FlipCardController();

  static String? groupDocumentId;
  static String? groupName;
  static String? userRef;
  static List? memberList;

  @override
  void initState() {
    super.initState();
    groupDocumentId = widget.groupDocumentId;
    groupName = widget.groupName;
    userRef = widget.userRef;
    memberList = widget.memberList;
    print(memberList);

    setState(() {
      changeView = false;
    });
  }

  void _showInBottomSheet(BuildContext context) {
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
                    seperateAmountTf(user1SeperateDebitController, "Anıl"),
                    SizedBox(
                      height: pageHeight * 0.03,
                    ),
                    seperateAmountTf(user2SeperateDebitController, "İbrahim"),
                    SizedBox(
                      height: pageHeight * 0.03,
                    ),
                    seperateAmountTf(selfSeperateDebitController, "Self"),
                    const Spacer(),
                    addSeperateButton(),
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

  //groups/m8RWw2Vof4nEV0otZKfM/YeniGrup/bakii/amounts

  late final FirebaseCollectionService _refUser1 = FirebaseCollectionService(
      "groups/$groupDocumentId/$groupName/${memberList![1].toString()}/amounts");
  late final FirebaseCollectionService _refUser2 = FirebaseCollectionService(
      "groups/$groupDocumentId/$groupName/${memberList![2].toString()}/amounts");

  Container addSeperateButton() {
    return Container(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 250, 161, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          setState(() {
            if (user1SeperateDebitController.text != "") {
              debitAmountSum -= int.parse(user1SeperateDebitController.text);
            }

            if (user2SeperateDebitController.text != "") {
              debitAmountSum -= int.parse(user2SeperateDebitController.text);
            }

            if (selfSeperateDebitController.text != "") {
              debitAmountSum -= int.parse(selfSeperateDebitController.text);
            }
            updateDebitSum();

            var userOption = userRef == memberList![0]
                ? "user1"
                : userRef == memberList![1]
                    ? "user2"
                    : "user1";

            if (user1SeperateDebitController.text != "") {
              _refUser1.update("userDebits", {
                userOption: (user1Debit +=
                        int.parse(user1SeperateDebitController.text))
                    .toString()
              });
            }
            if (user2SeperateDebitController.text != "") {
              _refUser2.update("userDebits", {
                userOption: (user2Debit +=
                        int.parse(user2SeperateDebitController.text))
                    .toString()
              });
            }
            user1SeperateDebitController.clear();
            user2SeperateDebitController.clear();
          });
        },
        child: Text(
          'Add Seperate Payment',
          style: GoogleFonts.prompt(
              color: const Color(0xffFFFFFF),
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  TextFormField seperateAmountTf(
      TextEditingController controller, String name) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: controller,
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
          hintText: name,
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
                    openSeperateBottomSheet(context),
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

  Container openSeperateBottomSheet(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 250, 161, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          _showInBottomSheet(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(FontAwesomeIcons.divide, color: Colors.white, size: 22),
            SizedBox(
              width: 8,
            ),
            Text(
              'Add Seperate Payment',
              style: GoogleFonts.prompt(
                  color: const Color(0xffFFFFFF),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  /*FirebaseCollectionService firebaseCollectionService =
      FirebaseCollectionService('users/baki/amounts');*/

  late FirebaseCollectionService firebaseCollectionService =
      FirebaseCollectionService(
          "groups/$groupDocumentId/$groupName/$userRef/amounts");

  void updateDebitSum() {
    firebaseCollectionService.update("debitSum", {
      'debitAmountSum': debitAmountSum.toString(),
    });
  }

  void addPayment() {
    print("Burası : " + 'groups/$groupDocumentId/$groupName/$userRef/amounts');
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FontAwesomeIcons.squarePlus,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              'Add Payment',
              style: GoogleFonts.prompt(
                  color: const Color(0xffFFFFFF),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ],
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
      bottomSheet: !changeView ? openPaymentBottomSheet() : null,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              flipCardController.flipcard();
              setState(() {
                changeView = !changeView;
              });
            },
            icon: const Icon(FontAwesomeIcons.repeat),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        toolbarHeight: 150,
        title: Text(
          "What\n$userRef Paids",
          style: GoogleFonts.prompt(fontSize: 48, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              card1(pageWidth, pageHeight, flipCardController,
                  name: userRef,
                  groupDocumentId: groupDocumentId,
                  groupName: groupName),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(FontAwesomeIcons.squarePlus,
                  color: Colors.white, size: 22),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Add Payment',
                style: GoogleFonts.prompt(
                    color: const Color(0xffFFFFFF),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
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
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xffE9E9E9)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: !changeView
            ? Column(
                children: [
                  SizedBox(
                    height: pageHeight * 0.03,
                  ),
                  debitList(pageHeight, pageWidth),
                ],
              )
            : userDebitView(pageWidth, pageHeight),
      ),
    );
  }

  Row userDebitView(double pageWidth, double pageHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //debitList(pageHeight, pageWidth),
        Column(
          children: [
            SizedBox(
              height: pageHeight * 0.03,
            ),
            Text(
              userRef != memberList![1] ? memberList![1] : memberList![0],
              style: GoogleFonts.prompt(
                  fontSize: 32,
                  color: const Color(0xff808080),
                  fontWeight: FontWeight.w500),
            ),
            getUser1Debit(pageWidth)
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: pageHeight * 0.03,
            ),
            Text(
              userRef != memberList![2] ? memberList![2] : memberList![0],
              style: GoogleFonts.prompt(
                  fontSize: 32,
                  color: const Color(0xff808080),
                  fontWeight: FontWeight.w500),
            ),
            getUser2Debit(pageWidth)
          ],
        ),
      ],
    );
  }

  StreamBuilder<DocumentSnapshot> getUser1Debit(double pageWidth) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _ref.doc("userDebits").snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          /*if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }*/

          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            user1Debit = int.parse(data["user1"].toString());

            return Expanded(
              child: SizedBox(
                width: pageWidth * 0.2,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: user1DebitController,
                  onSubmitted: (value) {
                    setState(() {
                      user1Debit = int.parse(value);

                      updateUserDebits();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: data["user1"].toString() + "zł",
                    contentPadding: EdgeInsets.only(left: 20),
                    hintStyle: GoogleFonts.prompt(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }

  TextEditingController user1DebitController = TextEditingController();
  TextEditingController user2DebitController = TextEditingController();

  StreamBuilder<DocumentSnapshot> getUser2Debit(double pageWidth) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _ref.doc("userDebits").snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            user2Debit = int.parse(data["user2"].toString());

            return Expanded(
              child: SizedBox(
                width: pageWidth * 0.2,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: user2DebitController,
                  onSubmitted: (value) {
                    setState(() {
                      user2Debit = int.parse(value);

                      updateUserDebits();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: data["user2"].toString() + "zł",
                    contentPadding: EdgeInsets.only(left: 20),
                    hintStyle: GoogleFonts.prompt(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }

  void deleteItem(int index, var item, List snap) async {
    setState(() {
      firebaseCollectionService.delete(item);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("$item dismissed")));
    setState(() {
      if (int.parse(snap[index]["amount"] as String) < debitAmountSum) {
        debitAmountSum =
            debitAmountSum - int.parse(snap[index]["amount"] as String);
      } else {
        debitAmountSum = 0;
      }
      updateDebitSum();
    });
  }

  void updateUserDebits() {
    if (user1DebitController.text != "") {
      firebaseCollectionService.update("userDebits", {
        'user1': user1Debit.toString(),
      });
      user1DebitController.clear();
    }
    if (user2DebitController.text != "") {
      firebaseCollectionService.update("userDebits", {
        'user2': user2Debit.toString(),
      });
      user2DebitController.clear();
    }
  }

  late CollectionReference _ref = FirebaseFirestore.instance
      .collection("groups/$groupDocumentId/$groupName/$userRef/amounts");

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
          "No payment added yet.",
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

Padding card1(
  double pageWidth,
  double pageHeight,
  flipCardController, {
  required String? name,
  required String? groupDocumentId,
  required String? groupName,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: pageWidth * 0.03),
    child: FlipCard(
      animationDuration: const Duration(milliseconds: 300),
      onTapFlipping: true,
      axis: FlipAxis.horizontal,
      frontWidget: card1Front(pageWidth, pageHeight,
          name: name, groupDocumentId: groupDocumentId, groupName: groupName),
      backWidget: card1Back(pageWidth, pageHeight,
          name: name, groupDocumentId: groupDocumentId, groupName: groupName),
      controller: flipCardController,
      rotateSide: RotateSide.right,
    ),
  );
}

Container card1Front(
  double pageWidth,
  double pageHeight, {
  required String? name,
  required String? groupDocumentId,
  required String? groupName,
}) {
  return Container(
    width: pageWidth,
    height: pageHeight * 0.25,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: name == _CardPageState.memberList![0]
            ? CardColors.red
            : name == _CardPageState.memberList![1]
                ? CardColors.green
                : CardColors.pink),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name.toString(),
            style:
                GoogleFonts.prompt(fontSize: 36, fontWeight: FontWeight.w700),
          ),
          getDebitAmountSum(
              groupDocumentId: groupDocumentId,
              groupName: groupName,
              userRef: name)
        ],
      ),
    ),
  );
}

Container card1Back(
  double pageWidth,
  double pageHeight, {
  required String? name,
  required String? groupDocumentId,
  required String? groupName,
}) {
  return Container(
    width: pageWidth,
    height: pageHeight * 0.25,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: name == _CardPageState.memberList![0]
            ? CardColors.red
            : name == _CardPageState.memberList![1]
                ? CardColors.green
                : CardColors.pink),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name.toString(),
            style:
                GoogleFonts.prompt(fontSize: 36, fontWeight: FontWeight.w700),
          ),
          getTotalDebit(
              groupDocumentId: groupDocumentId,
              groupName: groupName,
              userRef: name)
        ],
      ),
    ),
  );
}

StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> getDebitAmountSum(
    {required String? groupDocumentId,
    required String? groupName,
    required String? userRef}) {
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("groups/$groupDocumentId/$groupName/$userRef/amounts")
          .doc("debitSum")
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.hasData) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          debitAmountSum = int.parse(data["debitAmountSum"]);

          return Text(
            "${debitAmountSum}" + "zł",
            style:
                GoogleFonts.prompt(fontSize: 36, fontWeight: FontWeight.w700),
          );

          /*AnimatedFlipCounter(
              suffix: " zł",
              textStyle:
                  GoogleFonts.prompt(fontSize: 36, fontWeight: FontWeight.w700),
              value: debitAmountSum);*/
        }
        return CircularProgressIndicator();
      });
}

StreamBuilder<DocumentSnapshot<Object?>> getTotalDebit(
    {required String? groupDocumentId,
    required String? groupName,
    required String? userRef}) {
  return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("groups/$groupDocumentId/$groupName/$userRef/amounts")
          .doc("userDebits")
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.hasData) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          user1Debit = int.parse(data["user1"]);
          user2Debit = int.parse(data["user2"]);
          var userDebitSum = user1Debit +
              user2Debit; //int.parse(data["user1"]) + int.parse(data["user2"]);

          return Text(
            "Total Debit : " + "${userDebitSum}" + "zł",
            style:
                GoogleFonts.prompt(fontSize: 36, fontWeight: FontWeight.w700),
          );
        }
        return CircularProgressIndicator();
      });
}
