// Enums for better type safety
enum JobType { fullTime, partTime, internship }

enum ExperienceLevel { entry, intermediate, senior }

enum Profession {
  mobileDev,
  webDev,
  uiDesigner,
  productManager,
  dataScientist,
  other
}

// Extension methods to convert enums to readable strings
extension JobTypeString on JobType {
  String toDisplayString() {
    switch (this) {
      case JobType.fullTime:
        return 'Full Time';
      case JobType.partTime:
        return 'Part Time';
      case JobType.internship:
        return 'Internship';
    }
  }
}

extension ExperienceLevelString on ExperienceLevel {
  String toDisplayString() {
    switch (this) {
      case ExperienceLevel.entry:
        return 'Entry Level';
      case ExperienceLevel.intermediate:
        return 'Intermediate';
      case ExperienceLevel.senior:
        return 'Senior';
    }
  }
}

extension ProfessionString on Profession {
  String toDisplayString() {
    switch (this) {
      case Profession.mobileDev:
        return 'Mobile Developer';
      case Profession.webDev:
        return 'Web Developer';
      case Profession.uiDesigner:
        return 'UI Designer';
      case Profession.productManager:
        return 'Product Manager';
      case Profession.dataScientist:
        return 'Data Scientist';
      case Profession.other:
        return 'Other';
    }
  }
}

// Main job listing class
class Job {
  final String id;
  final String title;
  final String description;
  final String location;
  final String company;
  final String companyLogo;
  final JobType jobType;
  final String salary;
  final List<String> requirements;
  final bool isRemote;
  final ExperienceLevel experienceLevel;
  final Profession profession;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.company,
    this.companyLogo = '',
    required this.jobType,
    required this.salary,
    required this.requirements,
    this.isRemote = false,
    required this.experienceLevel,
    required this.profession,
  });
}

// Basic user class for authentication
class User {
  final String id;
  final String name;
  final String email;
  final List<String> appliedJobs; // Jobs swiped right (automatically applied)

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.appliedJobs,
  });
}

// Separate class for user preferences that can be modified in onboarding/settings
class UserPreferences {
  final String location;
  final ExperienceLevel experienceLevel;
  final Profession profession;
  final List<JobType> preferredJobTypes;
  final String expectedSalary;
  final bool remoteOnly;

  UserPreferences({
    required this.location,
    required this.experienceLevel,
    required this.profession,
    required this.preferredJobTypes,
    required this.expectedSalary,
    required this.remoteOnly,
  });
}
