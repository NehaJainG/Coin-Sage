import 'package:flutter/material.dart';

import 'package:coin_sage/models/transaction.dart';

//add new room icons
Icon addIcon = const Icon(Icons.add);
Icon addMemberIcon = const Icon(Icons.person_add_alt_1_rounded);
Icon roomTitle = const Icon(Icons.groups_2_rounded);
Icon searchMemberIcon = const Icon(Icons.person_search_rounded);
Icon person = const Icon(Icons.person);
Icon email = const Icon(Icons.email_rounded);
Icon password = const Icon(Icons.key_rounded);
//add new Expense icons
Icon rupeeIcon = const Icon(Icons.currency_rupee_rounded);
Icon calenderIcon = const Icon(Icons.calendar_month_rounded);

//Transaction type icon
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

//icons for categories:
// Map to associate icons with each category
const categoryIcons = {
  // Expense Categories
  ExpenseCategory.Groceries: Icons.shopping_cart,
  ExpenseCategory.Dining: Icons.fastfood,
  ExpenseCategory.Entertainment: Icons.movie,
  ExpenseCategory.Transportation: Icons.directions_car,
  ExpenseCategory.Utilities: Icons.lightbulb_outline,
  ExpenseCategory.RentMortgage: Icons.home,
  ExpenseCategory.Health: Icons.local_hospital,
  ExpenseCategory.Education: Icons.school,
  ExpenseCategory.PersonalCare: Icons.person,
  ExpenseCategory.Other: Icons.attach_money,

  // Income Categories
  IncomeCategory.Salary: Icons.account_balance,
  IncomeCategory.Freelance: Icons.work,
  IncomeCategory.Business: Icons.business,
  IncomeCategory.Investment: Icons.trending_up,
  IncomeCategory.Rental: Icons.home,
  IncomeCategory.Other: Icons.attach_money,

  // Debt Categories
  DebtCategory.Loan: Icons.attach_money,
  DebtCategory.Family: Icons.house_rounded,
  DebtCategory.Friend: Icons.people,
  DebtCategory.CreditCard: Icons.credit_card,
  DebtCategory.Other: Icons.attach_money,

  // Subscription Categories
  SubscriptionCategory.Streaming: Icons.tv,
  SubscriptionCategory.Magazine: Icons.chrome_reader_mode,
  SubscriptionCategory.GymMembership: Icons.fitness_center,
  SubscriptionCategory.OnlineServices: Icons.computer,
  SubscriptionCategory.Utilities: Icons.lightbulb_outline,
  SubscriptionCategory.Insurance: Icons.security,
  SubscriptionCategory.Other: Icons.attach_money,
};
