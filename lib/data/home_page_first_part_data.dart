import 'package:flutter/material.dart';

var menuodel = [
  Column(
    children: [
      SizedBox(
        width: 45,
        height: 45,
        child: Image.asset(
          'assets/icons/add_money.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading add money icon: $error');
            return Icon(Icons.add_circle_outline, size: 45, color: Colors.blue);
          },
        ),
      ),
      Text('Add')
    ],
  ),
  Column(
    children: [
      Container(
        child: Image.asset(
          'assets/icons/reffer.png',
          height: 47,
        ),
      ),
      Text(
        'Reffer',
      )
    ],
  ),
  Column(
    children: [
      Container(
        child: Image.asset(
          'assets/logo.png',
          color: Colors.redAccent,
          height: 45,
        ),
      ),
      Text(
        'Bkash',
      )
    ],
  ),
  Column(
    children: [
      Container(
        child: Image.asset(
          'assets/icons/nagad.png',
          height: 45,
        ),
      ),
      Text(
        'Nagad',
      )
    ],
  ),
  Column(
    children: [
      Container(
        child: Image.asset(
          'assets/icons/rocket.png',
          height: 45,
        ),
      ),
      Text('Rocket')
    ],
  ),
  Column(
    children: [
      Container(
        child: Image.asset('assets/icons/upay.png', height: 45),
      ),
      Text('Upay')
    ],
  ),
  Column(
    children: [
      Container(
        child: Image.asset('assets/icons/bank.png', height: 45),
      ),
      Text('Bank')
    ],
  ),
  Column(
    children: [
      Container(
        child: Image.asset(
          'assets/icons/report.png',
          height: 50,
        ),
      ),
      Text('Report')
    ],
  ),

/*  Column(
    children: [
      Container(
        child: Image.asset('assets/icons/history.png',height: 45,),
      ),
      Text('History')
    ],
  ),*/
];
