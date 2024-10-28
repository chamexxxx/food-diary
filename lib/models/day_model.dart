class DayModel {
  final int id;
  final String name;
  final String weekday;

  const DayModel({required this.id, required this.name, required this.weekday});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'weekday': weekday};
  }

  factory DayModel.fromMap(Map<String, dynamic> map) {
    return DayModel(id: map['id'], name: map['name'], weekday: map['weekday']);
  }
}
