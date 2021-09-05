import 'dart:convert';

class Page{
  int current = 0;
  int totalPages = 0;
  int totalResults = 0;

  Page();
  Page.fromJson(String json) {
    try {
      Map<String, dynamic> dict = jsonDecode(json);
      current = dict["page"];
      totalPages = dict["total_pages"];
      totalResults = dict["total_results"];
    }catch(e){
      print("Page.fromJson $e");
      throw e;
    }
  }

  @override
  String toString() {
    return "page: $current, totalPages:$totalPages, totalResults:$totalResults";
  }

  bool hasNext(){
    return (this.current < this.totalPages);
  }

}