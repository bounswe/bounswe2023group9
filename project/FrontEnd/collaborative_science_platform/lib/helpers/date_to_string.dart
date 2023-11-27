
const Map<int, String> months = {
  DateTime.january: "Jan",
  DateTime.february: "Feb",
  DateTime.march: "Mar",
  DateTime.april: "Apr",
  DateTime.may: "May",
  DateTime.june: "Jun",
  DateTime.july: "Jul",
  DateTime.august: "Aug",
  DateTime.september: "Sep",
  DateTime.october: "Oct",
  DateTime.november: "Nov",
  DateTime.december: "Dec",
};

String dateToString(DateTime dateTime) {
  String? month = months[dateTime.month];
  return "$month ${dateTime.day}, ${dateTime.year}";
}

String getDurationFromNow(DateTime dateTime) {
  DateTime now = DateTime.now();
  Duration duration = now.difference(dateTime);
  if (duration.inDays~/365 > 1) {
    return "${duration.inDays~/365} years ago";
  } else if (duration.inDays~/365 == 1) {
    return "1 year ago";
  } else if (duration.inDays~/30 > 1) {
    return "${duration.inDays~/30} months ago";
  } else if (duration.inDays~/30 == 1) {
    return "1 month ago";
  } else if (duration.inDays > 1) {
    return "${duration.inDays} days ago";
  } else if (duration.inDays == 1) {
    return "1 day ago";
  } else if (duration.inHours > 1) {
    return"${duration.inHours} hours ago";
  } else if (duration.inHours == 1) {
    return "1 hour ago";
  } else if (duration.inMinutes > 1) {
    return "${duration.inMinutes} minutes ago";
  } else if (duration.inMinutes == 1) {
    return "1 minute ago";
  } else {
    return "just now";
  }
}