import 'package:url_launcher/url_launcher.dart';

// Utility function to launch URLs
Future<void> openUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);  // Opens the URL in the browser
  } else {
    throw 'Could not launch $url';  // Handle errors if the URL can't be opened
  }
}
