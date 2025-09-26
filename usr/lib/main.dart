import "package:flutter/material.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Quiz App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const QuizScreen(),
    );
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  const Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = {};
  bool _quizFinished = false;
  int _score = 0;

  final List<Question> _questions = [
    const Question(
      questionText: "1. Stroop effect แสดงให้เห็นถึงกระบวนการทางปัญญาใด?",
      options: [
        "A) การเรียนรู้แบบเงื่อนไข (Conditioning)",
        "B) การเลือกสนใจ (Selective Attention)",
        "C) ความจำระยะยาว (Long-term memory)",
        "D) การแก้ปัญหาเชิงตรรกะ",
      ],
      correctAnswerIndex: 1,
    ),
    const Question(
      questionText: "2. ใน Stroop Task เงื่อนไขใดใช้เวลา (Reaction Time) นานที่สุด?",
      options: [
        "A) Congruent (คำกับสีตรงกัน)",
        "B) Incongruent (คำกับสีไม่ตรงกัน)",
        "C) Neutral (คำไม่เกี่ยวข้องกับสี เช่น \"xxx\")",
        "D) Random noise",
      ],
      correctAnswerIndex: 1,
    ),
    const Question(
      questionText: "3. Serial Position Effect อธิบายว่าเหตุใดคนจึงจำคำแรกและคำสุดท้ายได้ดีกว่าคำตรงกลาง?",
      options: [
        "A) Primacy & Recency effect",
        "B) Context effect",
        "C) Mood-congruent memory",
        "D) False memory effect",
      ],
      correctAnswerIndex: 0,
    ),
    const Question(
      questionText: "4. ใน Müller-Lyer illusion เส้นที่มี “ปีกหันออก” มักถูกมองว่า ________",
      options: [
        "A) สั้นกว่า",
        "B) ยาวกว่า",
        "C) เท่ากันเสมอ",
        "D) หายไปจากการมองเห็น",
      ],
      correctAnswerIndex: 1,
    ),
    const Question(
      questionText: "5. A* search algorithm แตกต่างจาก BFS อย่างไร?",
      options: [
        "A) ใช้ heuristic มาช่วยประเมินค่า",
        "B) เร็วกว่าเสมอ",
        "C) ไม่ต้องเก็บ parent state",
        "D) หาคำตอบผิดพลาดได้บ่อย",
      ],
      correctAnswerIndex: 0,
    ),
    const Question(
      questionText: "6. ทฤษฎี Prospect Theory เสนอว่า:",
      options: [
        "A) คนชอบความเสี่ยงเสมอ",
        "B) คนเกลียดการเสียมากกว่าที่ชอบการได้",
        "C) คนใช้ expected utility เท่านั้น",
        "D) คนตัดสินใจอย่างเป็นกลาง",
      ],
      correctAnswerIndex: 1,
    ),
    const Question(
      questionText: "7. ในการหมุนจินตภาพ (mental rotation) Reaction Time มัก ________ เมื่อมุมหมุนเพิ่มขึ้น",
      options: [
        "A) ลดลง",
        "B) ไม่เปลี่ยน",
        "C) เพิ่มขึ้น",
        "D) หายไป",
      ],
      correctAnswerIndex: 2,
    ),
    const Question(
      questionText: "8. ถ้าผู้เข้าทดลองมี false alarm rate สูง แสดงถึง…",
      options: [
        "A) inhibitory control ต่ำ",
        "B) memory capacity สูง",
        "C) multitasking ดี",
        "D) intelligence สูง",
      ],
      correctAnswerIndex: 0,
    ),
    const Question(
      questionText: "9. การจำแนกตาม prototype อาศัยอะไรเป็นหลัก?",
      options: [
        "A) ตัวอย่างที่เจอบ่อยที่สุด",
        "B) ค่าเฉลี่ยหรือ centroid ของกลุ่ม",
        "C) ข้อผิดพลาดจากการเรียนรู้",
        "D) การจำแบบ episodic memory",
      ],
      correctAnswerIndex: 1,
    ),
    const Question(
      questionText: "10. UCB1 algorithm เลือก arm โดยอาศัยหลักการ…",
      options: [
        "A) เลือกแบบสุ่มเท่านั้น",
        "B) เลือก arm ที่เคยได้ reward เฉลี่ยสูงสุด",
        "C) เลือก arm ที่ balance ระหว่างค่าประมาณ reward และความไม่แน่นอน",
        "D) เลือก arm ที่มีความน่าจะได้รางวัลน้อยที่สุด",
      ],
      correctAnswerIndex: 2,
    ),
  ];

  void _answerQuestion(int questionIndex, int optionIndex) {
    setState(() {
      _selectedAnswers[questionIndex] = optionIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _submitQuiz();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _submitQuiz() {
    int score = 0;
    _selectedAnswers.forEach((questionIndex, answerIndex) {
      if (_questions[questionIndex].correctAnswerIndex == answerIndex) {
        score++;
      }
    });
    setState(() {
      _score = score;
      _quizFinished = true;
    });
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _selectedAnswers.clear();
      _quizFinished = false;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Multiple Choice Quiz"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _quizFinished ? _buildResultScreen() : _buildQuizScreen(),
    );
  }

  Widget _buildQuizScreen() {
    final currentQuestion = _questions[_currentQuestionIndex];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Question ${_currentQuestionIndex + 1}/${_questions.length}",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            currentQuestion.questionText,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          ...List.generate(currentQuestion.options.length, (index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: RadioListTile<int>(
                title: Text(currentQuestion.options[index]),
                value: index,
                groupValue: _selectedAnswers[_currentQuestionIndex],
                onChanged: (value) {
                  if (value != null) {
                    _answerQuestion(_currentQuestionIndex, value);
                  }
                },
              ),
            );
          }),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentQuestionIndex > 0)
                ElevatedButton(
                  onPressed: _previousQuestion,
                  child: const Text("Previous"),
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: _nextQuestion,
                child: Text(
                  _currentQuestionIndex < _questions.length - 1
                      ? "Next"
                      : "Submit",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Quiz Finished!",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Text(
            "Your Score: $_score / ${_questions.length}",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _restartQuiz,
            child: const Text("Restart Quiz"),
          ),
        ],
      ),
    );
  }
}
