// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';
import 'package:upwork_myfirst_task/constents.dart';


/// Example event class.
class TaskModel {

  String uuid;
  Data data;
  String date;
  TaskModel({this.uuid,this.data, this.date});

  TaskModel.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    date = json['date'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['date'] = this.date;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {

  int startTime;
  int endTime;
  String title;
  String description;
  String attachmentPhoto;
  bool remindMe;
  int colorPicker;

  Data(
      {
        this.startTime,
        this.endTime,
        this.title,
        this.description,
        this.colorPicker,
        this.attachmentPhoto,
        this.remindMe});

  Data.fromJson(Map<String, dynamic> json) {
    colorPicker= json['colorPicker'];

    startTime = json['startTime'];
    endTime = json['endTime'];
    title = json['title'];
    description = json['description'];
    attachmentPhoto = json['attachmentPhoto'];
    remindMe = json['remindMe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['endTime'] = this.endTime;
    data['startTime'] = this.startTime;
    data['title'] = this.title;
    data['description'] = this.description;
    data['attachmentPhoto'] = this.attachmentPhoto;
    data['remindMe'] = this.remindMe;
    data['colorPicker'] = this.colorPicker;
    return data;
  }
}

//  Change the rang of calender date starts and end
final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);

//  For calender UI. No need to change


/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
var kEvents = LinkedHashMap<DateTime, List<TaskModel>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(kEventSource);

Map<DateTime, List<TaskModel>> kEventSource = Constants.eventMap;

setVal (val){
  kEventSource = val;
  kEvents = LinkedHashMap<DateTime, List<TaskModel>>(
    equals: isSameDay,
    hashCode: getHashCode,
  )..addAll(kEventSource);

}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}



