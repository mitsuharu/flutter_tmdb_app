// 定数群をまとめたクラス
class Constant{

  static var alert = Alert();
  static var app = App();
  static var cal = Cal();
  static var commons = Commons();
  static var info = Info();

}

class Commons{
  final String notFound = "見つかりません";
  final String nowLoading = "読み込み中";
}

class App{
  final String mainTitle = "最近の公開映画bb";
}

class Cal{
  final String successMessage = "カレンダーに登録しました";
  final String errorMessage = "カレンダー登録に失敗しました。カレンダーの認証もしくは設定を確認してください。";
}

class Alert{
  final String cancel = "Cancel";
  final String ok = "OK";

  final String titleDeleteTodo = "削除の確認";
  final String messageDeleteTodo = "Todoを削除しますか？";
}

class Info{
  final String title = "お知らせ";
}

