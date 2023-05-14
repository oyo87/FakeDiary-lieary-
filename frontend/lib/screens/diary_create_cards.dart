import 'package:flutter/material.dart';
import 'package:frontend/screens/home_circlemenu.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/model/CardModel.dart';
import 'package:frontend/screens/mood_select.dart';

import '../widgets/theme.dart';
import 'card_create.dart';

class DiaryCreateCards extends StatefulWidget {
  final int? cardIdFromList;

  const DiaryCreateCards({Key? key, this.cardIdFromList}) : super(key: key);

  @override
  _DiaryCreateState createState() => _DiaryCreateState();
}

class _DiaryCreateState extends State<DiaryCreateCards> {
  late Future<List<CardModel>> cards;
  late Future<int> lengthOfCards;
  late List<CardModel> selectedCards = [];

  @override
  void initState() {
    super.initState();
    cards = ApiService().getCardList();
    if (widget.cardIdFromList != null) {
      getCardFromList();
    }
    // for (int i=0 ; i<cards.length ; i++) {
    //   if(cards[i] == widget.cardIdFromList) {
    //
    //   }
    // }
    // int index = cards.(widget.cardIdFromList);

    // ApiService().getCardList().then((card) {
    //   setState(() {
    //     _card = card;
    //     // 선택한 카드의 인덱스를 찾습니다.
    //     int index =
    //         _card.indexWhere((card) => card.cardId == widget.cardIdFromList);
    //     print(index);
    //     setState(() {
    //       selectedCards.add(cards[index]);
    //     });
    //   });
    // });
  }

  getCardFromList() async {
    CardModel cardFromList =
        await ApiService.getCardById(widget.cardIdFromList!);
    selectedCards.add(cardFromList);
    setState(() {});
  }

  late int memberId;

  @override
  Widget build(BuildContext context) {
    return (Container(
        decoration: BgThemeGradient(),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: MediaQuery.of(context).size.height * 0.1183,
              actions: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'CARDS  ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            },
                            child: Image(
                              image: AssetImage(
                                'assets/img/home_icon.png',
                              ),
                              width: 45,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            body: Center(
                child: Column(children: [
              Flexible(
                flex: 2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 1000, // or whatever width works for your layout
                    height: 200, // or whatever height works for your layout
                    child: selectedList(selectedCards),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 0.3, color: Colors.white),
                    ),
                  ),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 15),
                          Text(
                            '이야기로 만들 기억의 조각을 선택하세요.',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                  flex: 4,
                  child: FutureBuilder<List<CardModel>>(
                      future: cards,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data == null || snapshot.data!.isEmpty) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CardCreate()));
                              },
                              child: Container(
                                width: 250,
                                height: 50,
                                decoration: BtnThemeGradient(),
                                child: Center(
                                  child: Text(
                                    '카드 만들러 가기',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              Flexible(
                                flex: 3,
                                child: buildList(snapshot.data),
                              ),
                              Flexible(
                                flex: 1,
                                child: ButtonCheck(),
                              )
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}에러!!");
                        }
                        return CircularProgressIndicator();
                      })),
            ])))));
  }

  Widget ButtonCheck() {
    if (selectedCards.isEmpty) {
      return Center(
        child: Text(
          '카드를 하나 이상 선택해주세요',
          style: TextStyle(color: Colors.white60),
        ),
      );
    }

    return GestureDetector(
      // NEXT 버튼을 누르면 장르선택 페이지로 간다.
      onTap: () {
        // navigate to the desired class
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MoodSelect(selectedCards: selectedCards)),
        );
      },
      child: Container(
          // NEXT 버튼
          width: 268,
          height: 61,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xff263344),
                const Color(0xff1B2532).withOpacity(0.53),
                const Color(0xff1C2A3D).withOpacity(0.5),
                const Color(0xff1E2E42).withOpacity(0.46),
                const Color(0xff364B66).withOpacity(0.33),
                const Color(0xff2471D6).withOpacity(0),
              ],
              stops: const [0, 0.25, 0.4, 0.5, 0.75, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff000000).withOpacity(0.25),
                offset: const Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'NEXT',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          )),
    );
  }

  String titleCheck(snapshot, index) {
    String title;

    if (snapshot[index].keywords.length != 0) {
      title = snapshot[index].keywords[0];
    } else if (snapshot[index].baseName != '') {
      title = snapshot[index].baseName;
    } else {
      print('sn: ${snapshot[index].basePlace}');
      title = snapshot[index].basePlace;
    }

    // 문자열이 10자 이상일 경우 잘라내고, "..."를 추가
    if (title.length > 10) {
      title = "${title.substring(0, 10)}...";
    }

    return title;
  }

  Widget buildList(snapshot) {
    return GridView.count(
      crossAxisCount: 3,
      // 가로 방향으로 3개의 카드씩 표시
      childAspectRatio: 0.7,
      // 카드의 가로 세로 비율 설정
      mainAxisSpacing: 10.0,
      // 카드들의 세로 간격 설정
      crossAxisSpacing: 10.0,
      // 카드들의 가로 간격 설정
      padding: EdgeInsets.all(10.0),
      // GridView 자체의 Padding 설정
      children: List.generate(
          // 카드 리스트 생성
          snapshot.length, // 총 카드 갯수
          (index) {
        return InkWell(
            onTap: () {
              setState(() {
                bool isExist = false;
                CardModel? delCard;
                for (CardModel card in selectedCards) {
                  if (card.cardId == snapshot[index].cardId) {
                    delCard = card;
                    isExist = true;
                  }
                }
                if (isExist) {
                  selectedCards.remove(delCard);
                }
                if (!isExist) {
                  if (selectedCards.length < 10) {
                    selectedCards.insert(
                        0, snapshot[index]); // append selected card to the list
                  } else {
                    // display a warning message
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('카드는 10장까지만 선택할 수 있습니다.'),
                    ));
                  }
                }
              });
            },
            // showModalBottomSheet(
            //   context: context,
            //   builder: (context) => .dart(
            //       cardIndex: index, cardTitle: titleCheck(snapshot, index)),
            // );

            child: Card(
              color: Colors.transparent,
              elevation: 0.0,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.white60, width: 4),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(snapshot[index].cardImageUrl))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(titleCheck(snapshot, index),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 12)),
                  ),
                ],
              ),
            ));
      }),
    );
  }

  Widget selectedList(selectedCards) {
    return GridView.count(
      childAspectRatio: 0.6,
      crossAxisCount: 10,
      // 가로 방향으로 3개의 카드씩 표시
      crossAxisSpacing: 10.0,
      // 카드들의 가로 간격 설정
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      // GridView 자체의 Padding 설정
      children: List.generate(
          // 카드 리스트 생성
          selectedCards.length, // 총 카드 갯수
          (index) {
        return InkWell(
            onTap: () {
              setState(() {
                selectedCards.remove(
                    selectedCards[index]); // append selected card to the list
              });
            },

            // onTap: () {
            //   showModalBottomSheet(
            //     context: context,
            //     builder: (context) => .dart(
            //         cardIndex: index, cardTitle: titleCheck(snapshot, index)),
            //   );
            // },
            child: Card(
              color: Colors.transparent,
              elevation: 0.0,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.white60, width: 4),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                selectedCards[index].cardImageUrl))),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(titleCheck(selectedCards, index),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 12)),
                  ),
                ],
              ),
            ));
      }),
    );
  }
}
