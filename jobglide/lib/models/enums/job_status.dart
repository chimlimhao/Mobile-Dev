enum JobStatus {
  saved,
  applied,
  rejected;

  String toDisplayString() {
    switch (this) {
      case JobStatus.saved:
        return 'Saved';
      case JobStatus.applied:
        return 'Applied';
      case JobStatus.rejected:
        return 'Rejected';
    }
  }
}
