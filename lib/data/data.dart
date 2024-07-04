import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Map<String, dynamic>> transactionsData = [
  {
    'icons': FaIcon(
      FontAwesomeIcons.burger,
      color: Colors.white,
    ),
    'color': Colors.yellow[700],
    'name': 'Food',
    'totalAmount': '-\$45.00',
    'date': 'Today',
  },
  {
    'icons': FaIcon(
      FontAwesomeIcons.bagShopping,
      color: Colors.white,
    ),
    'color': Colors.purple,
    'name': 'shopping',
    'totalAmount': '-\$285.00',
    'date': 'Today',
  },
  {
    'icons': FaIcon(
      FontAwesomeIcons.heartCircleCheck,
      color: Colors.white,
    ),
    'color': Colors.green,
    'name': 'Health',
    'totalAmount': '-\$79.00',
    'date': 'Yesterday',
  },
  {
    'icons': FaIcon(
      FontAwesomeIcons.plane,
      color: Colors.white,
    ),
    'color': Colors.blue,
    'name': 'Travel',
    'totalAmount': '-\$385.00',
    'date': 'Yesterday',
  },
];
