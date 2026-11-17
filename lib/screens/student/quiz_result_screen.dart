import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';
import 'quiz_screen.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final map = args is Map ? args : const {};
    final total = (map['total'] as int?) ?? quizQuestions.length;
    final score = (map['score'] as int?) ?? 0;
    final picked = (map['picked'] as List<int>?) ??
        List<int>.filled(quizQuestions.length, -1);
    final percent = total == 0 ? 0 : (score * 100 / total).round();
    final passed = percent >= 60;

    final weak = <String>{};
    for (int i = 0; i < quizQuestions.length; i++) {
      if (picked[i] != quizQuestions[i].answer) {
        weak.add(quizQuestions[i].topic);
      }
    }

    return AppShell(
      currentRoute: '/assessments',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 700;
          final pad = wide ? 24.0 : 16.0;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quiz Results',
                      style: GoogleFonts.manrope(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _scoreCard(score, total, percent, passed),
                    const SizedBox(height: 16),
                    _weakCard(context, weak),
                    const SizedBox(height: 16),
                    _review(picked),
                    const SizedBox(height: 16),
                    _actions(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _scoreCard(int score, int total, int percent, bool passed) {
    final color = passed ? AppColors.teal : const Color(0xFFB3261E);

    return AppCard(
      child: Row(
        children: [
          SizedBox(
            width: 84,
            height: 84,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 84,
                  height: 84,
                  child: CircularProgressIndicator(
                    value: percent / 100,
                    strokeWidth: 8,
                    backgroundColor: AppColors.chip,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Text(
                  '$percent%',
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Pill(
                  passed ? 'Passed' : 'Needs Review',
                  bg: passed ? AppColors.mint : const Color(0xFFFFE3E0),
                  fg: color,
                  fontSize: 10,
                ),
                const SizedBox(height: 8),
                Text(
                  '$score of $total correct',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  passed
                      ? 'Nice work. Your mastery is trending up.'
                      : 'Review the explanations below and try again.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    height: 1.4,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _weakCard(BuildContext context, Set<String> weak) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            weak.isEmpty ? 'No gaps found' : 'Topics to Reinforce',
            style: GoogleFonts.manrope(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          if (weak.isEmpty)
            Text(
              'You answered every question correctly.',
              style:
              GoogleFonts.inter(fontSize: 13, color: AppColors.textGrey),
            )
          else ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in weak)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE9CF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      t,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6B3A00),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/weak-topics'),
              child: Text(
                'Open Weak Topics',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _review(List<int> picked) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Answer Review',
            style: GoogleFonts.manrope(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < quizQuestions.length; i++)
            _reviewItem(i, picked[i]),
        ],
      ),
    );
  }

  Widget _reviewItem(int i, int pick) {
    final q = quizQuestions[i];
    final correct = pick == q.answer;
    final color = correct ? AppColors.teal : const Color(0xFFB3261E);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(correct ? Icons.check_circle : Icons.cancel,
                  size: 18, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${i + 1}. ${q.question}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            pick == -1
                ? 'Your answer: not answered'
                : 'Your answer: ${q.options[pick]}',
            style: GoogleFonts.inter(fontSize: 12, color: color),
          ),
          if (!correct) ...[
            const SizedBox(height: 4),
            Text(
              'Correct answer: ${q.options[q.answer]}',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.teal,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            q.explanation,
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 1.5,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actions(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ElevatedButton.icon(
          onPressed: () => Navigator.pushReplacementNamed(context, '/quiz'),
          icon: const Icon(Icons.replay, size: 18),
          label: const Text('Retake Quiz'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLight,
            minimumSize: const Size(0, 44),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle:
            GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/ai-tutor'),
          icon: const Icon(Icons.psychology_alt_outlined, size: 18),
          label: const Text('Ask AI Tutor'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.chip,
            foregroundColor: AppColors.textDark,
            elevation: 0,
            minimumSize: const Size(0, 44),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle:
            GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/assessments'),
          icon: const Icon(Icons.checklist, size: 18),
          label: const Text('Assessments'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.chip,
            foregroundColor: AppColors.textDark,
            elevation: 0,
            minimumSize: const Size(0, 44),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle:
            GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}