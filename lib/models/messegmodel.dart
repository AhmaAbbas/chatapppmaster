class MessageModel{
  String? id;
  String? content;
  String? date;
  MessageModel({this.content,this.id,this.date});
  factory MessageModel.fromjson(Map<String,dynamic> json )
  {
    return MessageModel(content: json["content"],id:json["id"] ,date:json["date"] );
  }
  Map<String,dynamic> tojson(){
    return {
      'id':id,
      'content':content,
      'date':date,
    };
  }
}