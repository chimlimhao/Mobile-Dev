enum JobType {
  fullTime,
  partTime,
  contract,
  internship;

  String toDisplayString() {
    switch (this) {
      case JobType.fullTime:
        return 'Full Time';
      case JobType.partTime:
        return 'Part Time';
      case JobType.contract:
        return 'Contract';
      case JobType.internship:
        return 'Internship';
    }
  }
}
