import 'package:flutter/material.dart';
import 'package:plane_me/models/auth.dart';
import 'package:plane_me/models/user_notes.dart';
import 'package:plane_me/profileScreen/profile_class.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:plane_me/translation/localizations.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<charts.Series<Pollution, String>> _seriesData;

  _generateDate() {
    var data1 = [
      new Pollution(2021, AppLocalizations.instance.translate("done"), done),
      new Pollution(
          2021, AppLocalizations.instance.translate("chores"), active),
      new Pollution(2021, AppLocalizations.instance.translate("prod"), created),
    ];

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2017',
        data: data1,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) => charts.ColorUtil.fromDartColor(
          Colors.deepOrangeAccent,
        ),
      ),
    );
  }

  sideStatistics() {
    return Flexible(
      child: Column(
        children: [
          SizedBox(
            height: 18,
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withAlpha(60),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  width: 42,
                  height: 42,
                  child: IconButton(
                    icon: Icon(
                      Icons.done_all,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                children: [
                  Text(
                    done.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    AppLocalizations.instance.translate("done"),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withAlpha(60),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  width: 42,
                  height: 42,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                children: [
                  Text(
                    active.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    AppLocalizations.instance.translate("active"),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withAlpha(60),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  width: 42,
                  height: 42,
                  child: IconButton(
                    icon: Icon(
                      Icons.save,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                children: [
                  Text(
                    created.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    AppLocalizations.instance.translate("created"),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  buildingGraphic() {
    return Container(
      height: 200,
      width: 200,
      child: Center(
        child: charts.BarChart(
          _seriesData,
          animate: true,
          barGroupingType: charts.BarGroupingType.grouped,
          animationDuration: Duration(seconds: 1),

          ///Isso é uma teste daqui pra baixo
          domainAxis: new charts.OrdinalAxisSpec(
              renderSpec: new charts.SmallTickRendererSpec(
                  labelStyle: new charts.TextStyleSpec(
                    fontSize: 10,

                    /// Size in Pts.
                    /// É dessa forma que altera as cores dos nomes
                    color: charts.MaterialPalette.white,
                  ),

                  /// Aqui é onde muda as cores da primeira linha inferior
                  lineStyle: new charts.LineStyleSpec(
                      color: charts.MaterialPalette.white))),
          primaryMeasureAxis: new charts.NumericAxisSpec(
            renderSpec: new charts.GridlineRendererSpec(

                /// Aqui você troca tudo dos números laterais
                labelStyle: new charts.TextStyleSpec(
                    fontSize: 16, color: charts.MaterialPalette.white),

                /// Muda as cores da linha
                lineStyle: new charts.LineStyleSpec(
                    color: charts.MaterialPalette.white)),
          ),
        ),
      ),
    );
  }

  topBarProfile() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {},
        child: CircleAvatar(
          radius: 42,
          child: ClipOval(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  userName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text(
            AppLocalizations.instance.translate("hello"),
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          Text(
            name,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  signOutBt() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepOrange.withAlpha(60),
              borderRadius: BorderRadius.all(
                Radius.circular(32),
              ),
            ),
            width: 62,
            height: 62,
            child: IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.grey,
              ),
              onPressed: () {
                signOuWithGoogle(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _seriesData = [];
    _generateDate();
    doneNotes();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 230,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: Colors.white12,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 32,
                  ),
                  topBarProfile(),
                  SizedBox(
                    height: 32,
                  ),
                  userName(),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildingGraphic(),
                SizedBox(
                  width: 16,
                ),
                sideStatistics(),
              ],
            ),
            signOutBt(),
          ],
        ),
      ),
    );
  }
}
