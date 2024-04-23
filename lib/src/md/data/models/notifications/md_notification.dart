class MDNotification {
  late final String senderID, message, title, details, procedureName,state;
  String? userID, topic;

  MDNotification({
    required this.senderID,
    required this.message,
    required this.title,
    required this.details,
    required this.procedureName,
    this.state='0',
    this.userID,
    this.topic,
  }) {
    if (topic == null && userID == null) {
      throw Exception('Topic or UserID must be provided');
    }else if(topic != null && userID != null){
      throw Exception('Only one of Topic or UserID must be provided');
    }
  }
}

mapNotification(MDNotification? notification) {
  if (notification == null) {
    return '';
  }
  if(notification.topic!=null){
    notification.topic= '/topics/${notification.topic}';
  }
  return '${notification.senderID}#${notification.userID ?? '0'}#${notification.title}#${notification
      .message}#${notification.details}#${notification.topic ?? '0'}#${notification.state}';
}
