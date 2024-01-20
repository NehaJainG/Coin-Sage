import 'package:flutter/material.dart';

import 'package:coin_sage/models/transaction.dart';

//add new room icons
Icon addIcon = const Icon(Icons.add);
Icon addMemberIcon = const Icon(Icons.person_add_alt_1_rounded);
Icon roomTitle = const Icon(Icons.groups_2_rounded);
Icon searchMemberIcon = const Icon(Icons.person_search_rounded);

//add new Expense icons
Icon rupeeIcon = const Icon(Icons.currency_rupee_rounded);

Map<TransactionType, Icon> iconList = {
  TransactionType.Expense: Icon(Icons.call_made_rounded),
  TransactionType.Income: Icon(Icons.call_received_rounded),
  TransactionType.Debt: Icon(Icons.currency_exchange_rounded),
  TransactionType.Subcriptions: Icon(Icons.description_outlined)
};

//add bottom navigation
Icon homeIcon = const Icon(Icons.home_outlined);
Icon chat = const Icon(Icons.chat_bubble_outline_rounded);
Icon setting = const Icon(Icons.settings_applications_rounded);
Icon statistic = const Icon(Icons.stacked_bar_chart_rounded);
Icon homeActive = const Icon(Icons.home_filled);
Icon statisticActive = const Icon(Icons.bar_chart_rounded);
Icon chatActive = const Icon(Icons.chat_bubble_rounded);
Icon settingActive = const Icon(Icons.settings);
