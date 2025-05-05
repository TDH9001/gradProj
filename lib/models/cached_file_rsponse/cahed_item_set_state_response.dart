import 'dart:io';

class CachedFileResult {
  final File? file;
  final bool isFailed;
  final double progress;
  final bool isLoading;

  CachedFileResult(
      {this.file,
      this.isFailed = false,
      this.progress = 0,
      this.isLoading = false});
}
