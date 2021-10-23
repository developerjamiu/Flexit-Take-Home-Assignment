/// Since this app is a small scale project, this is the class that will be ...
/// used to contain all errors in the app
class Failure {
  Failure(this.message);

  final String message;

  factory Failure.fromHttpErrorMap(Map<String, dynamic> map) => Failure(
        map["error"],
      );

  @override
  String toString() => 'Failure(message: $message)';
}