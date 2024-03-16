import 'package:coin_sage/models/reminder.dart';
import 'package:coin_sage/models/transaction.dart';

List<Map<String, String>> onBoardingData = [
  {
    'imagePath': 'assets/image/coin_sage.jpg',
    'title': 'Coin Sage',
    'description': 'Track, Pay, Prosper Together',
  },
  {
    'imagePath': 'assets/image/splash_image1.png',
    'title': 'Transaction Tracker',
    'description':
        ' Seamlessly monitor all your individual and group transactions in one place.',
  },
  {
    'imagePath': 'assets/image/splash_image2.png',
    'title': 'Payment Reminders',
    'description':
        'Never miss a payment again. Stay on top of your financial commitments and maintain healthy financial relationships effortlessly.',
  },
];

String signin = 'signin';
String signinHead = 'Welcome back!';

String signup = 'signup';
String signupHead = 'Create an account!';

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

String rupee = '₹';
