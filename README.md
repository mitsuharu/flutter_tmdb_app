# flutter tmdb app

A Flutter application for TMDb API


## Devlopment

### Api Key


You need to get Api key, then make `api_key.dart` at `lib/api/tmdb/api_key.dart`

- [My API Settings — The Movie Database (TMDB)](https://www.themoviedb.org/settings/api)


```dart
/// lib/api/tmdb/api_key.dart
class ApiConstants{
  static const String apiKey = "your_api_key";
}
```