

class Task {
  int? id;
  String ? name;
  String? description;
  String?date;
   bool? isChecked;

  taskMap(){

    var mapping= <String,dynamic>{};
    mapping['id'] = id ?? null;
    mapping['name'] = name!;
    mapping['description'] = description!;
    mapping['date']= date!;
    // mapping['isChecked']= isChecked ? 1 : 0;

    return mapping;
  }

}

