class AdminQuizFormScreen extends StatefulWidget {
  const AdminQuizFormScreen({super.key});

  @override
  _AdminQuizFormScreenState createState() => _AdminQuizFormScreenState();
}

class _AdminQuizFormScreenState extends State<AdminQuizFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _question = '';
  List<String> _choices = ['', '', '', ''];
  String _correctAnswer = '';

  Future<void> createQuiz() async {
    final response = await http.post(
      Uri.parse('your_api_url/admin/quizzes'), // Your backend API for quiz creation
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': _title,
        'question': _question,
        'choices': _choices,
        'correctAnswer': _correctAnswer,
      }),
    );

    if (response.statusCode == 201) {
      // Successfully created the quiz
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Quiz created successfully")));
      Navigator.pop(context); // Navigate back after success
    } else {
      // Handle error in quiz creation
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to create quiz")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer un quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quiz Title'),
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quiz title';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Question'),
                onChanged: (value) {
                  setState(() {
                    _question = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the question';
                  }
                  return null;
                },
              ),
              // Add input fields for choices and correct answer here...

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    createQuiz(); // Call the function to create the quiz
                  }
                },
                child: const Text('Create Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
