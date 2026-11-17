import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_shell.dart';

class _Msg {
  final String text;
  final bool fromUser;
  const _Msg(this.text, this.fromUser);
}

class AiTutorScreen extends StatefulWidget {
  const AiTutorScreen({super.key});

  @override
  State<AiTutorScreen> createState() => _AiTutorScreenState();
}

class _AiTutorScreenState extends State<AiTutorScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final List<_Msg> _messages = [
    const _Msg(
        'Hi Farah! Today we are on Neural Network Architectures. '
            'Before I explain anything: what do you think a hidden layer is for?',
        false),
  ];
  bool _typing = false;
  int _hintLevel = 0; // 0..3
  int _replyIndex = 0;

  static const _socratic = [
    'Good start. If a network had no hidden layer, what kind of patterns could it still learn? Try an example.',
    'Interesting. What would happen if every neuron used a purely linear activation? Think about stacking two layers.',
    'You are close. Why might a non-linear activation like ReLU let the network model more complex shapes?',
    'Nice reasoning. Can you explain in your own words how the output of one layer becomes the input of the next?',
  ];

  static const _hints = [
    'Hint 1: Think about what a single straight line can and cannot separate.',
    'Hint 2: Stacking linear layers without an activation collapses into one linear layer.',
    'Hint 3: Non-linear activations let each layer bend the decision boundary. Now try restating the idea.',
  ];

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _toBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _reply(String text) {
    setState(() => _typing = true);
    _toBottom();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _typing = false;
        _messages.add(_Msg(_text(text), false));
      });
      _toBottom();
    });
  }

  String _text(String _) {
    final r = _socratic[_replyIndex % _socratic.length];
    _replyIndex++;
    return r;
  }

  void _send([String? preset]) {
    final t = (preset ?? _input.text).trim();
    if (t.isEmpty || _typing) return;
    setState(() {
      _messages.add(_Msg(t, true));
      _input.clear();
    });
    _reply(t);
  }

  void _hint() {
    if (_typing) return;
    if (_hintLevel >= _hints.length) {
      setState(() => _messages.add(const _Msg(
          'You have used all three hints. Try putting the idea in your own words and I will check it.',
          false)));
      _toBottom();
      return;
    }
    setState(() {
      _messages.add(const _Msg('Can I get a hint?', true));
      _messages.add(_Msg(_hints[_hintLevel], false));
      _hintLevel++;
    });
    _toBottom();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/ai-tutor',
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 700;
          final pad = wide ? 24.0 : 16.0;
          final inner = c.maxWidth - pad * 2;
          final mainW = wide ? inner * 0.66 : inner;
          final sideW = wide ? inner - mainW - 16 : inner;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    SizedBox(width: mainW, child: _chat()),
                    SizedBox(
                      width: sideW,
                      child: Column(
                        children: [
                          _session(),
                          const SizedBox(height: 16),
                          _concepts(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Pill('Socratic Mode',
                bg: AppColors.mint, fg: AppColors.teal, fontSize: 10),
            Text(
              'CS 482 • Neural Network Architectures',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'AI Tutor',
          style: GoogleFonts.manrope(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Guided questions that help you reach the answer yourself.',
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.5,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _chat() {
    const suggestions = [
      'What is a hidden layer?',
      'Why use ReLU?',
      'Explain backpropagation',
    ];

    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 380,
            child: ListView.builder(
              controller: _scroll,
              itemCount: _messages.length + (_typing ? 1 : 0),
              itemBuilder: (context, i) {
                if (i >= _messages.length) return _typingBubble();
                return _bubble(_messages[i]);
              },
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in suggestions)
                ActionChip(
                  label: Text(
                    s,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  backgroundColor: AppColors.chip,
                  side: BorderSide.none,
                  onPressed: () => _send(s),
                ),
              ActionChip(
                avatar: const Icon(Icons.lightbulb_outline,
                    size: 14, color: AppColors.teal),
                label: Text(
                  'Give me a hint',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.teal,
                  ),
                ),
                backgroundColor: AppColors.mint,
                side: BorderSide.none,
                onPressed: _hint,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _input,
                  onSubmitted: (_) => _send(),
                  textInputAction: TextInputAction.send,
                  style: GoogleFonts.inter(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Type your answer or question...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textGrey,
                    ),
                    filled: true,
                    fillColor: AppColors.chip,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => _send(),
                  child: const SizedBox(
                    width: 46,
                    height: 46,
                    child: Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bubble(_Msg m) {
    final user = m.fromUser;
    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: user ? AppColors.primaryLight : const Color(0xFFF1F1FF),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(user ? 16 : 4),
              bottomRight: Radius.circular(user ? 4 : 16),
            ),
          ),
          child: Text(
            m.text,
            style: GoogleFonts.inter(
              fontSize: 13,
              height: 1.5,
              color: user ? Colors.white : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _typingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'Tutor is thinking...',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: AppColors.textGrey,
          ),
        ),
      ),
    );
  }

  Widget _title(String t) => Text(
    t,
    style: GoogleFonts.manrope(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: AppColors.textDark,
    ),
  );

  Widget _session() {
    Widget row(String label, String value, Color color) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textGrey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );

    final asked = _messages.where((m) => m.fromUser).length;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Session'),
          const SizedBox(height: 12),
          row('Your answers', '$asked', AppColors.textDark),
          row('Hints used', '$_hintLevel / 3', AppColors.primary),
          row('Confidence', '91%', AppColors.teal),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_hintLevel / 3).clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: AppColors.chip,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryLight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _concepts() {
    Widget chip(String t) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.mint,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        t,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.teal,
        ),
      ),
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Concepts Covered'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              chip('Hidden Layers'),
              chip('Activation Functions'),
              chip('Layer Stacking'),
            ],
          ),
        ],
      ),
    );
  }
}