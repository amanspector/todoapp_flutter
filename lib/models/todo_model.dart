import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoModel {
  String? todoid;
  String? title;
  String? task;
  DateTime? createdAt;
  DateTime? scheduleForDate;
  TimeOfDay? scheduleForTime;
  String? categoryName;
  String? categoryIcon;

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "task": task,
      "createdAt": craeteAt_formated(),
      "scheduleForDate": scheduleForDate != null
          ? DateToString(scheduleForDate!)
          : null,
      "scheduleForTime": scheduleForTime != null
          ? TimeToString(scheduleForTime!)
          : null,
      "categoryName": categoryName,
      "categoryIcon": categoryIcon,
    };
  }

  factory TodoModel.formjson(Map<String, dynamic> json, String docid) {
    return TodoModel(
      todoid: docid,
      title: json['title'],
      task: json['task'],
      createdAt: createAt_fromString(json['createdAt']),
      scheduleForDate: json['scheduleForDate'] != null
          ? StringtoDate(json['scheduleForDate'])
          : null,
      scheduleForTime: json['scheduleForTime'] != null
          ? StringToTime(json['scheduleForTime'])
          : null,
      categoryName: json['categoryName'],
      categoryIcon: json['categoryIcon'],
    );
  }

  String craeteAt_formated() {
    String date = DateFormat('MM/dd/yyyy - kk:mm').format(createdAt!);
    return date;
  }

  static DateTime createAt_fromString(String getDateString) {
    final DateFormat datef = DateFormat('MM/dd/yyyy - kk:mm');
    final DateTime dateConversion = datef.parse(getDateString);
    return dateConversion;
  }

  // String ScheduleFor_formated(){
  //   String date = DateFormat('MM/dd/yyyy - kk:mm').format(scheduleFor!);
  //   return date;
  // }

  static DateTime StringtoDate(String getDateString) {
    final DateFormat datef = DateFormat('dd/MM/yyyy');
    final DateTime dateConversion = datef.parse(getDateString);
    return dateConversion;
  }

  static String DateToString(DateTime getDateTime) {
    final DateFormat datef = DateFormat('dd/MM/yyyy');
    final String dateString1 = datef.format(getDateTime);
    return dateString1;
  }

  static TimeOfDay StringToTime(String getTime) {
    final dateformat = DateFormat.jm();
    final DateTime timeConvo = dateformat.parseLoose(getTime);
    return TimeOfDay.fromDateTime(timeConvo);
  }

  static String TimeToString(TimeOfDay getTime) {
    final now = DateTime.now();
    final temp = DateTime(
      now.year,
      now.month,
      now.day,
      getTime.hour,
      getTime.minute,
    );
    String setTimeString = DateFormat.jm().format(temp);
    return setTimeString;
  }

  TodoModel({
    this.todoid,
    required this.title,
    required this.task,
    required this.createdAt,
    required this.scheduleForDate,
    required this.scheduleForTime,
    required this.categoryName,
    required this.categoryIcon,
  });
}
