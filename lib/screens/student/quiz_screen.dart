import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int answer;
  final String explanation;
  final String topic;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
    required this.topic,
  });
}

const quizQuestions = [
  QuizQuestion(
    question: 'What is the main purpose of a hidden layer in a neural network?',
    options: [
      'To store the training data',
      'To learn intermediate representations of the input',
      'To reduce the number of output classes',
      'To normalize the learning rate',
    ],
    answer: 1,
    explanation:
    'Hidden layers transform inputs into intermediate features that make the final prediction easier.',
    topic: 'Hidden Layers',
  ),
  QuizQuestion(
    question: 'Why do we use non-linear activation functions such as ReLU?',
    options: [
      'They make training faster on every dataset',
      'They remove the need for weights',
      'Without them, stacked layers collapse into one linear transformation',
      'They guarantee no overfitting',
    ],
    answer: 2,
    explanation:
    'Stacking linear layers gives another linear function, so non-linearity is what lets deep networks model complex shapes.',
    topic: 'Activation Functions',
  ),
  QuizQuestion(
    question: 'Backpropagation relies mainly on which mathematical rule?',
    options: [
      'The chain rule',
      'Bayes rule',
      'The pigeonhole principle',
      'The triangle inequality',
    ],
    answer: 0,
    explanation:
    'Gradients are propagated backwards layer by layer by applying the chain rule.',
    topic: 'Backpropagation',
  ),
  QuizQuestion(
    question: 'Which symptom most clearly suggests overfitting?',
    options: [
      'High training error and high validation error',
      'Low training error but high validation error',
      'High training error and low validation error',
      'Identical training and validation error',
    ],
    answer: 1,
    explanation:
    'An overfit model memorizes training data, so it does well there but poorly on unseen data.',
    topic: 'Validation',
  ),
  QuizQuestion(
    question: 'In gradient descent, what does the learning rate control?',
    options: [
      'The number of hidden layers',
      'The size of each weight update step',
      'The size of the dataset',
      'The number of output neurons',
    ],
    answer: 1,
    explanation:
    'The learning rate scales each update. Too large can diverge, too small can be very slow.',
    topic: 'Optimization',
  ),
];

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _index = 0;
  late final List<int> _picked =
  List<int>.filled(quizQuestions.length, -1);
  int _secondsLeft = 20 * 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        _submit();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _clock {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _submit() {
    _timer?.cancel();
    int score = 0;
    for (int i = 0; i < quizQuestions.length; i++) {
      if (_picked[i] == quizQuestions[i].answer) score++;
    }
    Navigator.pushReplacementNamed(context, '/quiz-result', arguments: {
      'score': score,
      'total': quizQuestions.length,
      'picked': List<int>.from(_picked),
    });
  }

  void _confirmSubmit() {
    final unanswered = _picked.where((p) => p == -1).length;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit quiz?'),
        content: Text(unanswered == 0
            ? 'You answered every question.'
            : 'You still have $unanswered unanswered question(s).'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep going'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _submit();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    _header(),
                    const SizedBox(height: 16),
                    _questionCard(),
                    const SizedBox(height: 16),
                    _nav(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _header() {
    final total = quizQuestions.length;
    final low = _secondsLeft <= 60;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Quiz: Neural Networks',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Pill(
                _clock,
                bg: low ? const Color(0xFFFFE3E0) : AppColors.chip,
                fg: low ? const Color(0xFFB3261E) : AppColors.primary,
                fontSize: 11,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Question ${_index + 1} of $total • AI Fundamentals',
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_index + 1) / total,
              minHeight: 6,
              backgroundColor: AppColors.chip,
              valueColor:
              const AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _questionCard() {
    final q = quizQuestions[_index];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Pill(q.topic, fontSize: 10),
          const SizedBox(height: 12),
          Text(
            q.question,
            style: GoogleFonts.manrope(
              fontSize: 17,
              height: 1.4,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < q.options.length; i++) _option(i, q.options[i]),
        ],
      ),
    );
  }

  Widget _option(int i, String text) {
    final selected = _picked[_index] == i;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => _picked[_index] = i),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF1F1FF) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.primaryLight : AppColors.chip,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AppColors.primaryLight : AppColors.chip,
                ),
                child: Text(
                  String.fromCharCode(65 + i),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.4,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nav() {
    final last = _index == quizQuestions.length - 1;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed:
            _index == 0 ? null : () => setState(() => _index--),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Previous'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.chip,
              foregroundColor: AppColors.textDark,
              elevation: 0,
              minimumSize: const Size(0, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: last ? _confirmSubmit : () => setState(() => _index++),
            icon: Icon(last ? Icons.check : Icons.arrow_forward, size: 18),
            label: Text(last ? 'Submit' : 'Next'),
            style: ElevatedButton.styleFrom(
              backgroundColor: last ? AppColors.teal : AppColors.primaryLight,
              minimumSize: const Size(0, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}