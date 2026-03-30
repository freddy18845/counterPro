
class SyncResult {
  final int pushed;
  final int pulled;
  final int failed;
  final List<String> errors;

  SyncResult({
    required this.pushed,
    required this.pulled,
    required this.failed,
    required this.errors,
  });

  bool get hasErrors => errors.isNotEmpty;
  int get total => pushed + pulled;

  // merge two results together
  SyncResult operator +(SyncResult other) => SyncResult(
    pushed: pushed + other.pushed,
    pulled: pulled + other.pulled,
    failed: failed + other.failed,
    errors: [...errors, ...other.errors],
  );
}

