class PhoneBookState {
  String id;
  String state;

  PhoneBookState({
    required this.id,
    required this.state,
  });

  factory PhoneBookState.fromJSON(var json) {
    return PhoneBookState(
      id: json["id"],
      state: json["state"],
    );
  }
  List<PhoneBookState> fromList(var list) {
    final List<PhoneBookState> stateList = [];
    for (var i in list) {
      stateList.add(PhoneBookState.fromJSON(i));
    }
    return stateList;
  }
}
