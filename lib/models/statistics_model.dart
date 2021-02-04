class StatisticsModel {

  final String id;
  final int active;
  final int created;
  final int done;

  StatisticsModel({this.id, this.active, this.done, this.created});

  factory StatisticsModel.fromMap(Map data){
    return StatisticsModel(
      active: data['active'],
      created: data['created'],
      done: data['done'],
    );
  }

  factory StatisticsModel.fromDS(String id, Map<String, dynamic> data) {
    return StatisticsModel(
        id: id,
        active: data['active'],
        created: data['created'],
        done: data['done'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "active": active,
      "created": created,
      "done": done
    };
  }
}