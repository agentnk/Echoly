import 'script_document.dart';

enum ScriptLoadStatus { success, cancelled, failure }

class ScriptLoadResult {
  const ScriptLoadResult._({
    required this.status,
    this.document,
    this.errorMessage,
  });

  const ScriptLoadResult.success(ScriptDocument value)
      : this._(status: ScriptLoadStatus.success, document: value);

  const ScriptLoadResult.cancelled()
      : this._(status: ScriptLoadStatus.cancelled);

  const ScriptLoadResult.failure(String message)
      : this._(status: ScriptLoadStatus.failure, errorMessage: message);

  final ScriptLoadStatus status;
  final ScriptDocument? document;
  final String? errorMessage;

  bool get isSuccess => status == ScriptLoadStatus.success;

  bool get isCancelled => status == ScriptLoadStatus.cancelled;

  bool get isFailure => status == ScriptLoadStatus.failure;
}
