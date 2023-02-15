import 'package:http/http.dart' as http;


class RemortService{


  Future<String?> getQuestions(String url) async{
    print(url);
    var client = http.Client();
    var uri =  Uri.parse(url);
    var response = await client.get(uri);
    if(response.statusCode == 200){
      var json = response.body;
      print("Responce generated");
      return json;
    }
    return "error";
  }
}
