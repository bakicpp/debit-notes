import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debit_notes/constants/colors.dart';
import 'package:debit_notes/constants/vectors.dart';
import 'package:debit_notes/constants/widgets.dart';
import 'package:debit_notes/pages/card_pages/first_card_page.dart';
import 'package:debit_notes/pages/card_pages/second_card_page.dart';
import 'package:debit_notes/pages/card_pages/third_card_page.dart';
import 'package:debit_notes/pages/login_page.dart';
import 'package:debit_notes/services/auth_service.dart';
import 'package:debit_notes/services/firebase_service.dart';
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

  bool hasGroup = false;

  FirebaseCollectionService firebaseCollectionService =
      FirebaseCollectionService("users");

  void hasGroupQuery() async {
    var hasGroupQuery = await firebaseCollectionService.getByDocument(
        "${Auth().currentUser!.email}", "hasGroup");

    print(hasGroupQuery.toString());

    if (hasGroupQuery == "true") {
      setState(() {
        hasGroup = true;
      });
    }
    if (hasGroupQuery == "false") {
      setState(() {
        hasGroup = false;
        print("hasgroup:  $hasGroup");
      });
    }
  }

  @override
  void initState() {
    hasGroupQuery();
    // TODO: implement initState
    super.initState();
  }

  void createGroup() {
    if (groupNameController.text != "" &&
        firstFriendController.text != "" &&
        secondFriendController.text != "") {
      firebaseCollectionService.createGroupDocument(
          groupNameController.text,
          "inviteCode",
          3,
          firstFriendController.text,
          secondFriendController.text,
          yourNameController.text);
      firebaseCollectionService.update("${Auth().currentUser!.email}", {
        "hasGroup": true,
      });
      setState(() {
        hasGroup = true;
      });

      Navigator.pop(context);
    }
  }

  void joinGroup() async {
    if (inviteCodeController.text != "") {
      var firebase = FirebaseFirestore.instance;
      var querySnapshot = await firebase
          .collection('groups')
          .where('inviteCode', isEqualTo: inviteCodeController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String? documentId;
        querySnapshot.docs.forEach((document) {
          documentId = document.id;
        });

        FirebaseFirestore.instance
            .collection('groups')
            .doc(documentId.toString())
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            print('Document data: ${documentSnapshot.data()}');
            Map<String, dynamic>? data =
                documentSnapshot.data() as Map<String, dynamic>?;
            firebaseCollectionService.update("${Auth().currentUser!.email}", {
              "hasGroup": true,
              "groupName": data?["name"],
            });
          } else {
            print('Document does not exist on the database');
          }
        });

        setState(() {
          hasGroup = true;
        });
        Navigator.pop(context);
      } else {
        print('Belge bulunamadı!');
        return null;
      }
    }
  }

  final groupNameController = TextEditingController();
  final firstFriendController = TextEditingController();
  final secondFriendController = TextEditingController();
  final yourNameController = TextEditingController();
  final inviteCodeController = TextEditingController();

  void createGroupScreen(BuildContext context) {
    var pageHeight = MediaQuery.of(context).size.height;
    var pageWidth = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      isScrollControlled: true,
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
              height: pageHeight * 0.85,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: pageHeight * 0.03,
                    ),
                    Center(
                      child: Text(
                        "Create Group",
                        style: GoogleFonts.prompt(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: pageHeight * 0.03,
                    ),
                    Text(
                      "Group Name",
                    ),
                    SizedBox(
                      height: pageHeight * 0.02,
                    ),

                    HomePageTextField(
                      hintText: "Your group's name",
                      controller: groupNameController,
                    ),
                    SizedBox(
                      height: pageHeight * 0.03,
                    ),
                    Text(
                      "You",
                    ),
                    SizedBox(
                      height: pageHeight * 0.02,
                    ),
                    HomePageTextField(
                      hintText: "Your name",
                      controller: yourNameController,
                    ),
                    SizedBox(
                      height: pageHeight * 0.03,
                    ),
                    Text(
                      "First Friend",
                    ),

                    SizedBox(
                      height: pageHeight * 0.02,
                    ),
                    HomePageTextField(
                      hintText: "First friend's name",
                      controller: firstFriendController,
                    ),
                    SizedBox(
                      height: pageHeight * 0.03,
                    ),
                    Text(
                      "Second Friend",
                    ),
                    SizedBox(
                      height: pageHeight * 0.02,
                    ),
                    HomePageTextField(
                      hintText: "Second friend's name",
                      controller: secondFriendController,
                    ),
                    //openSeperateBottomSheet(context),
                    SizedBox(
                      height: pageHeight * 0.03,
                    ),
                    createGroupButton(pageHeight, pageWidth)
                  ],
                ),
              )),
        );
      },
    );
  }

  SizedBox createGroupButton(double pageHeight, double pageWidth) {
    return SizedBox(
      height: pageHeight / 16,
      width: pageWidth,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.purpleAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              )),
          onPressed: () {
            createGroup();
          },
          child: Text(
            "Create Group",
            style: GoogleFonts.manrope(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
          )),
    );
  }

  void joinGroupScreen(BuildContext context) {
    var pageHeight = MediaQuery.of(context).size.height;
    var pageWidth = MediaQuery.of(context).size.height;

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
              height: pageHeight * 0.8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: pageHeight * 0.03,
                    ),
                    Center(
                      child: Text(
                        "Join a Group with PIN",
                        style: GoogleFonts.prompt(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: pageHeight * 0.03,
                    ),
                    Text(
                      "Enter the group code",
                    ),
                    SizedBox(
                      height: pageHeight * 0.02,
                    ),
                    HomePageTextField(
                      hintText: "Ex: DN4234",
                      controller: inviteCodeController,
                    ),
                    SizedBox(
                      height: pageHeight * 0.03,
                    ),
                    joinGroupButton(pageHeight, pageWidth)
                  ],
                ),
              )),
        );
      },
    );
  }

  SizedBox joinGroupButton(double pageHeight, double pageWidth) {
    return SizedBox(
      height: pageHeight / 16,
      width: pageWidth,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.purpleAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              )),
          onPressed: joinGroup,
          child: Text(
            "Join a Group",
            style: GoogleFonts.manrope(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
          )),
    );
  }

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
          actions: [
            IconButton(
                onPressed: () {
                  Auth().signOut().then((value) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                            child: const LoginPage(),
                            type: PageTransitionType.leftToRightWithFade),
                        (route) => false);
                  });
                },
                icon: Icon(FontAwesomeIcons.signOut))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: pageWidth / 18),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: !hasGroup
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
          buttonsRow(pageHeight, pageWidth),
        ]);
  }

  Row buttonsRow(double pageHeight, double pageWidth) {
    return Row(
      children: [
        EmptyPageButtons(
          pageHeight: pageHeight,
          pageWidth: pageWidth,
          buttonText: "Create Group",
          onTap: () => createGroupScreen(context),
        ),
        SizedBox(
          width: pageWidth / 28,
        ),
        EmptyPageButtons(
          pageHeight: pageHeight,
          pageWidth: pageWidth,
          buttonText: "Join Group",
          onTap: () => joinGroupScreen(context),
        )
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
