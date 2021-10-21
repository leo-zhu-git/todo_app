class Goal1{
  int? id;
  String? name;
  String? description;

  goal1Map() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['description'] = description;

    return mapping; 
  }

    fromobject(dynamic obj)
  {
    id = obj['id'];
    name = obj['name'];
    description = obj['description'];

  }
}