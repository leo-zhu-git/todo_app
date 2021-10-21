class Action1{
  int? id;
  String? name;
  String? description;

  action1Map() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['description'] = description;

    return mapping; 
  }

  fromObject(dynamic obj)
  {
    id = obj['id'];
    name = obj['name'];
    description = obj['description'];


  }


  
}