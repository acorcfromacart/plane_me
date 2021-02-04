
class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;
  final bool shareable;
  final bool archieve;

  EventModel({this.id, this.description, this.title, this.eventDate, this.shareable, this.archieve});

  factory EventModel.fromMap(Map data) {
    return EventModel(
      title: data['title'],
      description: data['description'],
      eventDate: data['event_date'],
      shareable: data['shareable'],
      archieve: data['archieve']
    );
  }

  factory EventModel.fromDS(String id, Map<String, dynamic> data) {
    return EventModel(
      id: id,
      title: data['title'],
      description: data['description'],
      eventDate: data['event_date'].toDate(),
      shareable: data['shareable'],
      archieve: data['archieve']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "event_date": eventDate,
      "shareable": shareable,
      "archieve": archieve
    };
  }
}
