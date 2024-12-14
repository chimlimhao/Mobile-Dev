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
  Job(
    id: '4',
    title: 'React Native Developer',
    description:
        'Join our team to build cross-platform mobile applications using React Native.',
    location: 'Austin, TX',
    company: 'TechCorp',
    jobType: JobType.fullTime,
    salary: '\$90,000 - \$120,000',
    requirements: [
      'React Native experience',
      'JavaScript expertise',
      'Mobile development background'
    ],
    isRemote: true,
    experienceLevel: ExperienceLevel.intermediate,
    profession: Profession.mobileDev,
  ),
  Job(
    id: '5',
    title: 'Junior Mobile Developer',
    description:
        'Great opportunity for recent graduates to start their mobile development career.',
    location: 'Seattle, WA',
    company: 'StartupX',
    jobType: JobType.fullTime,
    salary: '\$65,000 - \$80,000',
    requirements: [
      'CS Degree',
      'Basic mobile development knowledge',
      'Strong learning attitude'
    ],
    isRemote: false,
    experienceLevel: ExperienceLevel.entry,
    profession: Profession.mobileDev,
  ),
  Job(
    id: '6',
    title: 'Mobile UI/UX Designer',
    description:
        'Design beautiful and intuitive mobile interfaces for our products.',
    location: 'Remote',
    company: 'DesignHub',
    jobType: JobType.fullTime,
    salary: '\$85,000 - \$110,000',
    requirements: [
      '3+ years UI design',
      'Mobile design portfolio',
      'Figma expertise'
    ],
    isRemote: true,
    experienceLevel: ExperienceLevel.intermediate,
    profession: Profession.uiDesigner,
  ),
  Job(
    id: '7',
    title: 'Part-time Mobile Developer',
    description:
        'Flexible part-time position for experienced mobile developers.',
    location: 'Chicago, IL',
    company: 'FlexTech',
    jobType: JobType.partTime,
    salary: '\$50/hour',
    requirements: [
      'Mobile development experience',
      'Flexible schedule',
      'Independent worker'
    ],
    isRemote: true,
    experienceLevel: ExperienceLevel.intermediate,
    profession: Profession.mobileDev,
  ),
  Job(
    id: '8',
    title: 'Senior Mobile Architect',
    description:
        'Lead our mobile development team and architect our mobile solutions.',
    location: 'Boston, MA',
    company: 'Enterprise Solutions',
    jobType: JobType.fullTime,
    salary: '\$140,000 - \$180,000',
    requirements: [
      '8+ years mobile development',
      'Architecture experience',
      'Team leadership'
    ],
    isRemote: false,
    experienceLevel: ExperienceLevel.senior,
    profession: Profession.mobileDev,
  ),
  Job(
    id: '9',
    title: 'Mobile QA Engineer',
    description:
        'Ensure quality of our mobile applications through manual and automated testing.',
    location: 'Remote',
    company: 'QualityFirst',
    jobType: JobType.fullTime,
    salary: '\$70,000 - \$90,000',
    requirements: [
      'Mobile testing experience',
      'Automation skills',
      'Quality mindset'
    ],
    isRemote: true,
    experienceLevel: ExperienceLevel.intermediate,
    profession: Profession.mobileDev,
  ),
  Job(
    id: '10',
    title: 'Mobile Game Developer',
    description:
        'Create exciting mobile games using Unity and native platforms.',
    location: 'Los Angeles, CA',
    company: 'GameStudio',
    jobType: JobType.fullTime,
    salary: '\$95,000 - \$125,000',
    requirements: [
      'Unity experience',
      'Game development background',
      '3D graphics knowledge'
    ],
    isRemote: false,
    experienceLevel: ExperienceLevel.intermediate,
    profession: Profession.mobileDev,
  ),
  // Add more jobs as needed...
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
