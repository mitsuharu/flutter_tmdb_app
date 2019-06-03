// 定数群をまとめたクラス
class Constant{

  static var alert = Alert();
  static var app = App();

  static var commons = Commons();

}

class Commons{
  final String notFound = "見つかりません";
  final String nowLoading = "読み込み中";
}

class App{
  final String startTodoApp = "TODOを追加しよう";
}

class Alert{
  final String cancel = "Cancel";
  final String ok = "OK";

  final String titleDeleteTodo = "削除の確認";
  final String messageDeleteTodo = "Todoを削除しますか？";

}

