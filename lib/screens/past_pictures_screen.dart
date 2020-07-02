import 'package:date_format/date_format.dart' show formatDate, dd, MM, yyyy;
import 'package:flutter/material.dart';

import '../constants.dart' show earliestPossibleDate, whiteTextStyle;
import '../models/space_media.dart';
import '../services/get_apod.dart';
import '../strings.dart';
import '../widgets/app_drawer.dart' show AppDrawer;
import '../widgets/background_gradient.dart';
import '../widgets/custom_button.dart';
import 'details_screen.dart';

class PastPicturesScreen extends StatelessWidget {
  static const routeName = '/time-machine';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(prevScreen: PastPicturesScreen.routeName),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          Strings.pastPicturesScreenTitle,
          textAlign: TextAlign.start,
          style: whiteTextStyle,
        ),
      ),
      body: BackgroundGradient(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.top),
          child: const TimeMachineContent(prevScreen: routeName),
        ),
      ),
    );
  }
}

class TimeMachineContent extends StatefulWidget {
  final String prevScreen;
  const TimeMachineContent({this.prevScreen});
  @override
  _TimeMachineContentState createState() => _TimeMachineContentState();
}

class _TimeMachineContentState extends State<TimeMachineContent> {
  DateTime _selectedDate = DateTime.now();
  // ignore: prefer_final_fields
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: earliestPossibleDate,
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _getSpaceMedia() async {
    setState(() {
      _isLoading = true;
    });
    final SpaceMedia spaceMedia = await getAPOD(date: _selectedDate);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailsScreen(),
        settings: RouteSettings(arguments: {
          'enablePageView': false,
          'spaceMedia': spaceMedia,
        }),
      ),
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          Strings.date,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 20),
        DateText(selectedDate: _selectedDate),
        const SizedBox(height: 20),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CustomButton(
                text: Strings.selectDate,
                onPressed: () {
                  _selectDate(context);
                },
              ),
              CustomButton(
                text: Strings.getPic,
                onPressed: _getSpaceMedia,
              ),
            ],
          )
      ],
    );
  }
}

class DateText extends StatelessWidget {
  const DateText({
    Key key,
    @required DateTime selectedDate,
  })  : _selectedDate = selectedDate,
        super(key: key);

  final DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Text(
      formatDate(_selectedDate, [MM, ' ', dd, ', ', yyyy]),
      style: const TextStyle(color: Colors.white, fontSize: 30),
    );
  }
}
