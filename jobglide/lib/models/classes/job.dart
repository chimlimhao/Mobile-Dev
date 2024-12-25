import 'application_method.dart';
import '../enums/job_type.dart';

class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String description;
  final List<String> requirements;
  final JobType jobType;
  final bool isRemote;
  final String profession;
  final ApplicationMethod applicationMethod;
  final DateTime postedDate;
  final String salary;
  final String? companyWebsite;
  final String? applicationStatus;
  final DateTime? appliedDate;

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.requirements,
    required this.jobType,
    required this.isRemote,
    required this.profession,
    required this.applicationMethod,
    required this.postedDate,
    required this.salary,
    this.companyWebsite,
    this.applicationStatus,
    this.appliedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'description': description,
      'requirements': requirements,
      'jobType': jobType.toString(),
      'isRemote': isRemote,
      'profession': profession,
      'applicationMethod': applicationMethod.toJson(),
      'postedDate': postedDate.toIso8601String(),
      'salary': salary,
      'companyWebsite': companyWebsite,
      'applicationStatus': applicationStatus,
      'appliedDate': appliedDate?.toIso8601String(),
    };
  }

  factory Job.fromJson(Map<String, dynamic> json) {
    // Helper function to safely cast to List<String>
    List<String> safeStringList(dynamic value) {
      if (value is List) {
        return value.map((e) => e?.toString() ?? '').toList();
      }
      return [];
    }

    return Job(
      id: json['id']?.toString() ?? 'unknown',
      title: json['title']?.toString() ?? 'Unknown Job',
      company: json['company']?.toString() ?? 'Unknown Company',
      location: json['location']?.toString() ?? 'Remote',
      description:
          json['description']?.toString() ?? 'No description available',
      requirements: safeStringList(json['requirements']),
      jobType: JobType.values.firstWhere(
        (e) => e.toString() == json['jobType'],
        orElse: () => JobType.fullTime,
      ),
      isRemote: json['isRemote'] as bool? ?? false,
      profession: json['profession']?.toString() ?? 'Unknown',
      applicationMethod: json['applicationMethod'] is Map
          ? ApplicationMethod.fromJson(
              json['applicationMethod'] as Map<String, dynamic>)
          : const ApplicationMethod(
              type: 'email', value: 'unknown@example.com'),
      postedDate: json['postedDate'] != null
          ? DateTime.parse(json['postedDate'] as String)
          : DateTime.now(),
      salary: json['salary']?.toString() ?? 'Competitive',
      companyWebsite: json['companyWebsite']?.toString(),
      applicationStatus: json['status']?.toString(),
      appliedDate: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
    );
  }
}
