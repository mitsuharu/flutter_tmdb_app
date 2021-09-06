// 定数群をまとめたクラス
class Constant{
  static var app = App();
  static var cal = Cal();
  static var commons = Commons();
  static var info = Info();
  static var error = Error();
}

class Commons{
  final String notFound = "見つかりません";
  final String nowLoading = "読み込み中";
}

class App{
  final String mainTitle = "最近の公開映画";
}

class Cal{
  final String successMessage = "カレンダーに登録しました";
  final String errorMessage = "カレンダー登録に失敗しました。カレンダーの認証もしくは設定を確認してください。";
}

class Error{
  final String networkFailed = "ネットワークに接続できませんでした。ネットワーク設定の確認、または時間をおいて再度お試しください。";
  final String unknown = "失敗しました。ネットワーク設定の確認、または時間をおいて再度お試しください。";
}

class Info{
  final String title = "お知らせ";
}

