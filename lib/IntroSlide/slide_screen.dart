import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:plane_me/translation/localizations.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List<Slide>.empty();

  Function goToTab;

  @override
  void initState() {
    super.initState();
    slides.add(
      new Slide(
        title: AppLocalizations.instance.translate("first_slide_title"),
        styleTitle: TextStyle(
            color: Colors.deepOrangeAccent,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Ubuntu'),
        description: AppLocalizations.instance.translate("first_slide_desc"),
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontFamily: 'Ubuntu'),
        pathImage: "images/connect_img.png",
      ),
    );
    slides.add(
      new Slide(
        title: AppLocalizations.instance.translate("second_slide_title"),
        styleTitle: TextStyle(
            color: Colors.deepOrangeAccent,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Ubuntu'),
        description: AppLocalizations.instance.translate("second_slide_desc"),
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontFamily: 'Ubuntu'),
        pathImage: "images/update_img.png",
      ),
    );
    slides.add(
      new Slide(
        title: AppLocalizations.instance.translate("third_slide_title"),
        styleTitle: TextStyle(
            color: Colors.deepOrangeAccent,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description: AppLocalizations.instance.translate("third_slide_desc"),
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontFamily: 'Ubuntu'),
        pathImage: "images/help_img.png",
      ),
    );
  }

  void onDonePress() {
    // Back to the first tab
    //this.goToTab(0);
    Navigator.of(context).pushReplacementNamed('/validation');
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Colors.deepOrangeAccent,
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Colors.deepOrangeAccent,
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Colors.deepOrangeAccent,
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List<Widget>.empty();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                  child: Image.asset(
                    currentSlide.pathImage,
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.contain,
                  )),
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              Container(
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      // List slides
      slides: this.slides,

      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Color(0x33ffcc5c),
      highlightColorSkipBtn: Color(0xffffcc5c),

      // Next button
      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn: Color(0x33ffcc5c),
      highlightColorDoneBtn: Color(0xffffcc5c),

      // Dot indicator
      colorDot: Colors.deepOrangeAccent,
      sizeDot: 13.0,
      typeDotAnimation: dotSliderAnimation.DOT_MOVEMENT,

      // Tabs
      listCustomTabs: this.renderListCustomTabs(),
      backgroundColorAllSlides: Colors.white,
      refFuncGoToTab: (refFunc) {
        this.goToTab = refFunc;
      },

      // Show or hide status bar
      shouldHideStatusBar: true,

      // On tab change completed
      onTabChangeCompleted: this.onTabChangeCompleted,
    );
  }
}
