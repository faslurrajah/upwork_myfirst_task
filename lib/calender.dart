
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:upwork_myfirst_task/constents.dart';

import 'task_model.dart';



class CalenderEvent extends StatefulWidget {
  @override
  _CalenderEventState createState() => _CalenderEventState();
}

class _CalenderEventState extends State<CalenderEvent> {
  ValueNotifier<List<TaskModel>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  bool isFinished = false;


  List <Map> myData = [
  {"uuid":"e3a83203-d282-477b-bcb8-664797ad4ddb",
    "date":"Dec 26, 2021",
    "data":{"title":"Title1","description":"Description","startTime":1640496283802,"endTime":1640498083804,"colorPicker":4284955319,"attachmentPhoto":"/Users/homeuser2/Library/Developer/CoreSimulator/Devices/128427F1-1557-418B-8036-7DDA87456E10/data/Containers/Data/Application/1867BFA4-CE17-497C-87B9-54AA8EEE6819/tmp/image_picker_C73ED33F-C67E-48D9-A58F-CE921D437F2B-54832-00002124E1640350.jpg","remindMe":true}},

  {"uuid":"e3a83203-d282-477b-bcb8-664797ad4ddb","date":"Dec 27, 2021","data":{"title":"Title2","description":"Description","startTime":1640496283802,"endTime":1640498083804,"colorPicker":4284955319,"attachmentPhoto":"/Users/homeuser2/Library/Developer/CoreSimulator/Devices/128427F1-1557-418B-8036-7DDA87456E10/data/Containers/Data/Application/1867BFA4-CE17-497C-87B9-54AA8EEE6819/tmp/image_picker_C73ED33F-C67E-48D9-A58F-CE921D437F2B-54832-00002124E1640350.jpg","remindMe":true}},

  {"uuid":"e3a83203-d282-477b-bcb8-664797ad4ddb","date":"Dec 26, 2021","data":{"title":"Title3","description":"Description","startTime":1640496283802,"endTime":1640498083804,"colorPicker":4284955319,"attachmentPhoto":"/Users/homeuser2/Library/Developer/CoreSimulator/Devices/128427F1-1557-418B-8036-7DDA87456E10/data/Containers/Data/Application/1867BFA4-CE17-497C-87B9-54AA8EEE6819/tmp/image_picker_C73ED33F-C67E-48D9-A58F-CE921D437F2B-54832-00002124E1640350.jpg","remindMe":true}},
  {"uuid":"e3a83203-d282-477b-bcb8-664797ad4ddb","date":"Dec 26, 2021","data":{"title":"Title4NEW","description":"Description","startTime":1640496283802,"endTime":1640498083804,"colorPicker":4289815319,"attachmentPhoto":"/Users/homeuser2/Library/Developer/CoreSimulator/Devices/128427F1-1557-418B-8036-7DDA87456E10/data/Containers/Data/Application/1867BFA4-CE17-497C-87B9-54AA8EEE6819/tmp/image_picker_C73ED33F-C67E-48D9-A58F-CE921D437F2B-54832-00002124E1640350.jpg","remindMe":true}}
  ];

  convertData() {
    // For the calender, we need to supply date and event
    Map<DateTime, List<TaskModel>> temp = {};
    // Converting data into TaskEvent
    myData.forEach((myDataValue) {
      DateFormat format = DateFormat("MMM dd, yyyy");
      DateTime formattedDate = format.parse(myDataValue['date']); // Converting Dec,Nov format to DateTime
      // Single day can have multiple events. Here I'm checking it and adding those as list
      bool newEvent = false;
      var oldKey ;
      temp.keys.forEach((element) {
        if(element.toString().substring(0,11)==formattedDate.toString().substring(0,11)) {
          newEvent = true;
          oldKey = element;
        }
      });
      if(!newEvent) { //If single event
        temp[formattedDate]=[TaskModel( uuid: myDataValue['uuid'],data: Data.fromJson(myDataValue['data']),date: myDataValue['date']  )];
      } else { // If multiple event occurred in same day
        temp[oldKey].add(TaskModel(uuid: myDataValue['uuid'],data: Data.fromJson(myDataValue['data']),date: myDataValue['date'] ));
      }
      //temp[formattedDate]=[Event(myDataValue['data']['title'])];
    });
    // Store the converted list of task model in a static variable
    Constants.eventMap = temp;
    setVal(temp);
    setState(() {
      isFinished = true;
    });
  }

  @override
  void initState() {
    super.initState();
    convertData();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }



  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<TaskModel> _getEventsForDay(DateTime day) {
    return kEvents[day];
  }



  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;

      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remind Task'),

      ),
      body: isFinished ? Column(
        children: [
          TableCalendar<TaskModel>(
            daysOfWeekStyle: const DaysOfWeekStyle(

            ),
            headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true
            ),
            calendarBuilders: CalendarBuilders(

              // ignore: missing_return
              markerBuilder: (context,day,event){
                List<Widget> markers  = [];
                for (TaskModel element in event) {
                  markers.add( CircleAvatar(radius: 4,backgroundColor: Color(element.data.colorPicker)));
                }
                return Center(
                  child: event.isNotEmpty ? Stack(
                    children: [
                      CircleAvatar(
                        //backgroundColor: Colors.redAccent,
                        child: Text(
                          '${day.day}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                              children:markers
                            //CircleAvatar(radius: 4,backgroundColor: Colors.black,),
                          )
                      )
                    ],
                  ):SizedBox(),
                );
              },
              // ignore: missing_return
              dowBuilder: (context, day) {
                if (day.weekday == DateTime.sunday || day.weekday == DateTime.saturday ) {
                  final text = DateFormat.E().format(day);

                  return Center(
                    child: Text(
                      text,
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  );
                }
              },
            ),
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,

            ),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<TaskModel>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return value!=null ? ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 10,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          //border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 6,
                                  color: Color(value[index].data.colorPicker),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${value[index].data.title}',),
                                    Text('${value[index].data.description}',),
                                    Row(
                                      children: [
                                        Text( DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(value[index].data.startTime)).toString()+ ' - '),
                                        Text( DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(value[index].data.endTime)).toString()),
                                      ],
                                    ),



                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ):Text('No Events');
              },
            ),
          ),
        ],
      ):Center(child: CupertinoActivityIndicator()),
    );
  }
}
