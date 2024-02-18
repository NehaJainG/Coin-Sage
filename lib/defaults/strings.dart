import 'package:coin_sage/models/transaction.dart';

String signin = 'signin';
String signinHead = 'Welcome back!';
String signinSub = 'Make your life simpler';

String signup = 'signup';
String signupHead = 'Create an account';
String signupSub = 'Make your life simpler';

Map<Reminder, String> reminderStr = {
  Reminder.OnDay: 'On Day',
  Reminder.OneDayBefore: 'One Day Before',
  Reminder.TwoDayBefore: 'Two Day Before',
  Reminder.FiveDayBefore: 'Five Day Before',
};

Map<Repeat, String> repeatStr = {
  Repeat.DontRepeat: 'Dont Repeat',
  Repeat.Month: 'Monthly',
  Repeat.Week: 'Weekly',
  Repeat.Year: 'Yearly',
};
