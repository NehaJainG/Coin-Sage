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

Map<TransactionType, String> roomTransaction = {
  TransactionType.Debt: 'Borrowed',
  TransactionType.Expense: 'Expense',
  TransactionType.Income: 'Contribute',
  TransactionType.Subcriptions: 'Bills&Tax',
};
