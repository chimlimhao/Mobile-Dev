import '../models/models.dart';

final List<Job> dummyJobs = [
  // Mobile Development Jobs
  Job(
    id: 'mobile_001',
    title: 'Senior Flutter Developer',
    company: 'TechCorp',
    location: 'San Francisco, CA',
    description:
        'Lead our mobile development team in building innovative Flutter applications.',
    requirements: [
      '5+ years of Flutter development experience',
      'Strong knowledge of state management solutions',
      'Experience leading development teams',
      'Excellent architectural and problem-solving skills',
    ],
    jobType: JobType.fullTime,
    isRemote: true,
    profession: 'Mobile Developer',
    applicationMethod: const ApplicationMethod(
      type: 'email',
      value: 'careers@techcorp.com',
      instructions:
          'Please include your resume and portfolio of Flutter projects.',
    ),
    postedDate: DateTime(2024, 12, 23),
    salary: '\$120,000 - \$160,000',
    companyWebsite: 'https://techcorp.com',
  ),
  Job(
    id: 'mobile_002',
    title: 'Mobile Developer',
    company: 'StartUp Inc',
    location: 'New York, NY',
    description:
        'Join our fast-paced team building cross-platform mobile applications with Flutter.',
    requirements: [
      '2+ years of mobile development experience',
      'Proficiency in Flutter and Dart',
      'Experience with RESTful APIs',
      'Knowledge of mobile app architecture',
    ],
    jobType: JobType.fullTime,
    isRemote: false,
    profession: 'Mobile Developer',
    applicationMethod: const ApplicationMethod(
      type: 'email',
      value: 'jobs@startupinc.com',
      instructions:
          'Send your resume and cover letter explaining your interest in mobile development.',
    ),
    postedDate: DateTime(2024, 12, 24),
    salary: '\$90,000 - \$120,000',
    companyWebsite: 'https://startupinc.com',
  ),
  Job(
    id: 'mobile_003',
    title: 'Flutter Developer Intern',
    company: 'MobileFirst Co',
    location: 'Remote',
    description:
        'Great opportunity for students to gain hands-on experience with Flutter development.',
    requirements: [
      'Currently pursuing CS or related degree',
      'Basic knowledge of Flutter/Dart',
      'Strong learning ability',
      'Good communication skills',
    ],
    jobType: JobType.internship,
    isRemote: true,
    profession: 'Mobile Developer',
    applicationMethod: const ApplicationMethod(
      type: 'email',
      value: 'internships@mobilefirst.com',
      instructions:
          'Include your academic transcript and any personal projects.',
    ),
    postedDate: DateTime(2024, 12, 22),
    salary: '\$30,000 - \$45,000',
    companyWebsite: 'https://mobilefirst.com',
  ),

  // Design Jobs
  Job(
    id: 'design_001',
    title: 'Senior UI/UX Designer',
    company: 'Creative Solutions',
    location: 'Los Angeles, CA',
    description:
        'Lead the design of beautiful and intuitive user interfaces for our products.',
    requirements: [
      '5+ years of UI/UX design experience',
      'Expert in Figma and Adobe Creative Suite',
      'Strong portfolio of mobile and web designs',
      'Experience with design systems',
    ],
    jobType: JobType.fullTime,
    isRemote: true,
    profession: 'Design',
    applicationMethod: const ApplicationMethod(
      type: 'email',
      value: 'design@creativesolutions.com',
      instructions: 'Share your portfolio and design process examples.',
    ),
    postedDate: DateTime(2024, 12, 24),
    salary: '\$100,000 - \$140,000',
    companyWebsite: 'https://creativesolutions.com',
  ),
  Job(
    id: 'design_002',
    title: 'Product Designer',
    company: 'DesignWorks',
    location: 'Seattle, WA',
    description:
        'Create user-centered designs for web and mobile applications.',
    requirements: [
      '3+ years of product design experience',
      'Proficiency in design tools',
      'Understanding of UX principles',
      'Experience with user research',
    ],
    jobType: JobType.fullTime,
    isRemote: false,
    profession: 'Design',
    applicationMethod: const ApplicationMethod(
      type: 'email',
      value: 'careers@designworks.com',
      instructions: 'Submit your portfolio and case studies.',
    ),
    postedDate: DateTime(2024, 12, 23),
    salary: '\$85,000 - \$120,000',
    companyWebsite: 'https://designworks.com',
  ),

  // Engineering Jobs
  Job(
    id: 'eng_001',
    title: 'Senior DevOps Engineer',
    company: 'CloudTech',
    location: 'Austin, TX',
    description:
        'Lead our DevOps practices and cloud infrastructure management.',
    requirements: [
      '5+ years of DevOps experience',
      'Expert in AWS/Azure',
      'Strong knowledge of CI/CD',
      'Infrastructure as Code experience',
    ],
    jobType: JobType.fullTime,
    isRemote: true,
    profession: 'Engineering',
    applicationMethod: const ApplicationMethod(
      type: 'email',
      value: 'devops@cloudtech.com',
      instructions:
          'Include details of infrastructure projects you\'ve managed.',
    ),
    postedDate: DateTime(2024, 12, 24),
    salary: '\$130,000 - \$180,000',
    companyWebsite: 'https://cloudtech.com',
  ),
  Job(
    id: 'eng_002',
    title: 'Backend Engineer',
    company: 'TechStack Inc',
    location: 'Chicago, IL',
    description: 'Develop and maintain scalable backend services.',
    requirements: [
      '3+ years backend development experience',
      'Proficiency in Python/Node.js',
      'Database design experience',
      'API development expertise',
    ],
    jobType: JobType.fullTime,
    isRemote: false,
    profession: 'Engineering',
    applicationMethod: const ApplicationMethod(
      type: 'email',
      value: 'engineering@techstack.com',
      instructions: 'Share your GitHub profile and significant projects.',
    ),
    postedDate: DateTime(2024, 12, 23),
    salary: '\$100,000 - \$140,000',
    companyWebsite: 'https://techstack.com',
  ),

  // Data Science Jobs
  Job(
    id: 'data_001',
    title: 'Senior Data Scientist',
    company: 'DataCorp',
    location: 'Boston, MA',
    description: 'Lead data science initiatives and machine learning projects.',
    requirements: [
      'PhD in Computer Science or related field',
      'Expert in Python and ML frameworks',
      'Experience with big data technologies',
      'Strong research background',
    ],
    jobType: JobType.fullTime,
    isRemote: true,
    profession: 'Data Science',
    applicationMethod: const ApplicationMethod(
      type: 'email',
      value: 'careers@datacorp.com',
      instructions: 'Include your research papers and project portfolio.',
    ),
    postedDate: DateTime(2024, 12, 24),
    salary: '\$140,000 - \$200,000',
    companyWebsite: 'https://datacorp.com',
  ),
  Job(
    id: 'data_002',
    title: 'Machine Learning Engineer',
    company: 'AI Solutions',
    location: 'Remote',
    description: 'Develop and deploy machine learning models in production.',
    requirements: [
      'MS in Computer Science or related field',
      'Strong ML/DL experience',
      'Production ML deployment experience',
      'Excellent coding skills',
    ],
    jobType: JobType.fullTime,
    isRemote: true,
    profession: 'Data Science',
    applicationMethod: const ApplicationMethod(
      type: 'email',
      value: 'ml@aisolutions.com',
      instructions: 'Share your ML project portfolio and GitHub profile.',
    ),
    postedDate: DateTime(2024, 12, 23),
    salary: '\$120,000 - \$160,000',
    companyWebsite: 'https://aisolutions.com',
  ),

  // Software Development Jobs
  Job(
    id: 'sw_001',
    title: 'Senior Software Developer',
    company: 'TechSolutions',
    location: 'Seattle, WA',
    description:
        'Join our team to build scalable enterprise software solutions.',
    requirements: [
      '5+ years of software development experience',
      'Strong knowledge of modern programming languages',
      'Experience with cloud platforms (AWS/Azure)',
      'Excellent problem-solving skills',
    ],
    jobType: JobType.fullTime,
    isRemote: true,
    profession: 'Software Developer',
    applicationMethod: const ApplicationMethod(
      type: 'email',
      value: 'careers@techsolutions.com',
      instructions:
          'Please include your resume and relevant project experience.',
    ),
    postedDate: DateTime(2024, 12, 23),
    salary: '\$130,000 - \$180,000',
    companyWebsite: 'https://techsolutions.com',
  ),
  Job(
    id: 'sw_002',
    title: 'Full Stack Software Developer',
    company: 'InnovateCorp',
    location: 'Boston, MA',
    description:
        'Build and maintain modern web applications using cutting-edge technologies.',
    requirements: [
      '3+ years of full-stack development experience',
      'Proficiency in JavaScript/TypeScript',
      'Experience with modern frameworks (React, Node.js)',
      'Strong database design skills',
    ],
    jobType: JobType.fullTime,
    isRemote: true,
    profession: 'Software Developer',
    applicationMethod: const ApplicationMethod(
      type: 'email',
      value: 'jobs@innovatecorp.com',
      instructions: 'Send your resume and portfolio of recent projects.',
    ),
    postedDate: DateTime(2024, 12, 23),
    salary: '\$100,000 - \$150,000',
    companyWebsite: 'https://innovatecorp.com',
  ),
];

// Example user for testing
final List<User> dummyUsers = [
  const User(
    id: 'user_001',
    name: 'Chim Limhao',
    email: 'test@example.com',
    autoApplyEnabled: false,
    preferences: UserPreferences(
      professions: ['Mobile Developer'],
      remoteOnly: true,
      preferredJobTypes: [JobType.fullTime, JobType.internship],
    ),
    jobStatuses: {},
  ),
];
