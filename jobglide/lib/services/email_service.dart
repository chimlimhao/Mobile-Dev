import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../models/models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

class EmailService {
  static final String _smtpHost = dotenv.env['SMTPHOST'] ?? '';
  static final int _smtpPort = int.parse(dotenv.env['SMTPPORT'] ?? '');
  static final String _username = dotenv.env['USERNAME'] ?? '';
  static final String _password = dotenv.env['PASSWORD'] ?? '';

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
      final professionsList = user.preferences.professions;
      final mainProfession =
          professionsList.isNotEmpty ? professionsList.first : job.profession;

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
${professionsList.isNotEmpty ? professionsList.map((p) => "- Experience in $p").join("\n") : "- Experience in ${job.profession}"}

${job.applicationMethod.instructions ?? 'I have attached my resume for your review.'}

I am particularly interested in this role because it offers an opportunity to contribute to ${job.company} 
while leveraging my experience in $mainProfession.
'''}

Best regards,
${user.name}
${user.email}
''';

      if (_username == 'your.email@gmail.com') {
        debugPrint('\n--- Email that would be sent ---');
        debugPrint('To: ${job.applicationMethod.value}');
        debugPrint('Subject: ${message.subject}');
        debugPrint('Body:\n${message.text}');
        debugPrint('---------------------------\n');
        return true;
      }

      await send(message, _smtpServer);
      return true;
    } catch (e) {
      debugPrint('Error sending email: $e');
      return false;
    }
  }

  static void configure({
    required String username,
    required String password,
  }) {
    return;
  }
}
