class APIPath {
  static String taskDBPath(
    String userId,
    String taskId,
  ) =>
      '/users/$userId/tasks/$taskId';

  static String tasksPath(
    String userId,
  ) =>
      'users/$userId/tasks';

  static String entryIDPath(
    String userId,
    String entryId,
  ) =>
      'users/$userId/entries/$entryId';

  static String entryPath(
    String userId,
  ) =>
      'users/$userId/entries';
}

