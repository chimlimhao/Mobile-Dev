import '../models/model.dart';

final List<Job> dummyJobs = [
  Job(
    id: '1',
    title: 'Flutter Developer',
    description:
        'We are looking for a Flutter developer to join our team. You will be responsible for developing mobile applications using Flutter framework.',
    location: 'New York, NY',
    company: 'Tech Start-up',
    companyLogo: 'assets/images/company1.png',
    jobType: JobType.fullTime,
    salary: '\$80,000 - \$100,000',
    requirements: [
      'Experience with Flutter and Dart',
      'Knowledge of mobile app development',
      'Good problem-solving skills'
    ],
    isRemote: true,
    experienceLevel: ExperienceLevel.intermediate,
    profession: Profession.mobileDev,
  ),
  Job(
    id: '2',
    title: 'Mobile Developer Intern',
    description:
        'Looking for an intern to assist in mobile app development projects. Great opportunity to learn and grow.',
    location: 'San Francisco, CA',
    company: 'Mobile Apps Inc',
    companyLogo: 'assets/images/company2.png',
    jobType: JobType.internship,
    salary: '\$25/hour',
    requirements: [
      'Currently pursuing CS degree',
      'Basic knowledge of mobile development',
      'Eager to learn'
    ],
    isRemote: false,
    experienceLevel: ExperienceLevel.entry,
    profession: Profession.mobileDev,
  ),
  Job(
    id: '3',
    title: 'Senior UI Designer',
    description:
        'Looking for an experienced UI designer to lead our design team and create beautiful mobile experiences.',
    location: 'Remote',
    company: 'DesignCo',
    companyLogo: 'assets/images/company3.png',
    jobType: JobType.fullTime,
    salary: '\$120,000 - \$150,000',
    requirements: [
      'At least 5 years of UI design experience',
      'Strong portfolio of mobile apps',
      'Team leadership experience'
    ],
    isRemote: true,
    experienceLevel: ExperienceLevel.senior,
    profession: Profession.uiDesigner,
  ),
];

final List<User> dummyUsers = [
  User(
    id: '1',
    name: 'John Doe',
    email: 'john@example.com',
    appliedJobs: [],
  ),
];

final userPreferences = UserPreferences(
  location: 'New York, NY',
  experienceLevel: ExperienceLevel.intermediate,
  profession: Profession.mobileDev,
  preferredJobTypes: [JobType.fullTime, JobType.partTime],
  expectedSalary: '\$90,000',
  remoteOnly: false,
);
