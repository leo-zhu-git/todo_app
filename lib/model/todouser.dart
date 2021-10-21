class todoUser{
  int? id;
  String? userID;
  String? email;

  todouserMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['userid'] = userID;
    mapping['email'] = email;

    return mapping; 
  }

  fromobject(dynamic obj)
  {
    id = obj['id'];
    userID= obj['userid'];
    email = obj['email'];

  }
}