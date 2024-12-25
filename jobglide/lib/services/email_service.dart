import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../models/model.dart';

class EmailService {
  // These would typically come from environment variables or secure storage
  static const String _smtpHost = 'smtp.gmail.com';
  static const int _smtpPort = 587;
  static const String _username = 'tonoforlife@gmail.com';
  static const String _password = 'caca sgei vrms vbci';

  static SmtpServer get _smtpServer => SmtpServer(
        _smtpHost,
        port: _smtpPort,
        username: _username,
        password: _password,
        ssl: false,
        allowInsecure: true,
      );

  static Future<bool> sendJobApplication({
    required User user,
    required Job job,
    String? customMessage,
  }) async {
    try {
      // Create the email message
      final message = Message()
        ..from = Address(_username, 'JobGlide App')
        ..recipients.add(job.applicationMethod.value)
        ..subject = 'Application for ${job.title} position at ${job.company}'
        ..text = '''
Dear Hiring Manager,

I am writing to express my interest in the ${job.title} position at ${job.company}.

${customMessage ?? '''
I am ${user.name} and I found this opportunity through JobGlide. Based on the job requirements, 
I believe my skills and experience make me a strong candidate for this role.

My key qualifications align well with your requirements:
${user.preferences.professions.map((p) => "- Experience in $p").join("\n")}

${job.applicationMethod.instructions ?? 'I have attached my resume for your review.'}

I am particularly interested in this role because it offers an opportunity to contribute to ${job.company} 
while leveraging my experience in ${user.preferences.professions.first}.
'''}

Best regards,
${user.name}
${user.email}
''';

      if (_username == 'your.email@gmail.com') {
        // Demo mode - just print the email
        print('\n--- Email that would be sent ---');
        print('To: ${job.applicationMethod.value}');
        print('Subject: ${message.subject}');
        print('Body:\n${message.text}');
        print('---------------------------\n');
        return true;
      }

      // Send the email and assume success if no exception is thrown
      await send(message, _smtpServer);
      return true;

    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }

  /// Configure the email service with your credentials
  static void configure({
    required String username,
    required String password,
  }) {
    // In a real app, you'd store these securely
    // For demo, we'll just update the static fields
    // _username = username;
    // _password = password;
  }
}
