import 'package:coin_sage/models/reminder.dart';
import 'package:coin_sage/models/transaction.dart';

String signin = 'signin';
String signinHead = 'Welcome back!';
String signinSub = 'Make your life simpler';

String signup = 'signup';
String signupHead = 'Create an account';
String signupSub = 'Make your life simpler';

Map<Alert, String> alertStr = {
  Alert.OnDay: 'On Day',
  Alert.OneDayBefore: 'One Day Before',
  Alert.TwoDayBefore: 'Two Day Before',
  Alert.FiveDayBefore: 'Five Day Before',
};

Map<Repeat, String> repeatStr = {
  Repeat.DontRepeat: 'Dont Repeat',
  Repeat.Month: 'Monthly',
  Repeat.Week: 'Weekly',
  Repeat.Year: 'Yearly',
};

String notificationTitle = 'Payment Reminders';

String getMessage(Transaction t, String name) {
  return "Heyy $name, reminder for ${t.title} which dues on ${dateFormatter.format(t.dueDate!)} and of amount ${t.amount}";
}
