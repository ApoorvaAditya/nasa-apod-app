import 'package:date_format/date_format.dart' show formatDate, dd, MM, yyyy;
import 'package:flutter/material.dart';
import 'package:nasa_apod_app/screens/details_screen.dart';
import 'package:provider/provider.dart';

import '../constants.dart' show earliestPossibleDate;
import '../services/media.dart';
import '../widgets/app_drawer.dart' show AppDrawer;
import '../widgets/background_gradient.dart';
import '../widgets/custom_button.dart';

class TimeMachineScreen extends StatelessWidget {
  static const routeName = '/time-machine';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Media(loadAhead: true),
      child: Scaffold(
        drawer: const AppDrawer(prevScreen: TimeMachineScreen.routeName),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Time Machine',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: BackgroundGradient(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.top),
            child: const TimeMachineContent(prevScreen: routeName),
          ),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Date',
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
                text: 'Select Date',
                onPressed: () {
                  _selectDate(context);
                },
              ),
              CustomButton(
                text: 'Get Pic',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DetailsScreen(),
                      settings: const RouteSettings(arguments: {}),
                    ),
                  );
                },
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
