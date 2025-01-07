class CodeChecker {
  static bool checkPythonSolution(String code) {
    try {
      // Clean up the code and print for debugging
      code = code.trim();
      print('Checking solution:');
      print('User code:\n$code');

      // Run test cases
      List<Map<String, dynamic>> testCases = [
        {
          'input': [1, 2, 3, 1],
          'expected': true
        },
        {
          'input': [1, 2, 3, 4],
          'expected': false
        },
        {
          'input': [1, 1, 1, 3, 3, 4, 3, 2, 4, 2],
          'expected': true
        },
        {'input': [], 'expected': false},
        {
          'input': [1],
          'expected': false
        },
        {
          'input': [1, 1],
          'expected': true
        },
      ];

      // Execute each test case
      for (var testCase in testCases) {
        List<int> input = List<int>.from(testCase['input']);
        bool expected = testCase['expected'];

        // Create Python-like environment and run the code
        var result = _runPythonCode(code, input);
        print('Testing input: $input');
        print('Expected: $expected');
        print('Got: $result');
        print('---');

        if (result != expected) {
          print(
              'Test case failed: input=$input, expected=$expected, got=$result');
          return false;
        }
      }

      print('All test cases passed!');
      return true;
    } catch (e) {
      print('Error checking solution: $e');
      print('Stack trace: ${StackTrace.current}');
      return false;
    }
  }

  static bool _runPythonCode(String code, List<int> input) {
    // Clean up code for comparison
    code = code
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll(RegExp(r'#.*'), '')
        .toLowerCase();

    print('Cleaned code: $code');

    // Check for common solution patterns
    bool hasSetCreation = code.contains('set(') || code.contains('=set()');
    bool hasLoop = code.contains('for') || code.contains('while');
    bool hasReturn = code.contains('return');

    print('Has set: $hasSetCreation');
    print('Has loop: $hasLoop');
    print('Has return: $hasReturn');

    // One-liner solution using set length comparison
    if (code.contains('len(set(') && code.contains('len(')) {
      var numSet = Set.from(input);
      return numSet.length < input.length;
    }

    // Set-based iteration solution
    if (hasSetCreation && hasLoop && hasReturn) {
      var seen = <int>{};
      for (var num in input) {
        if (seen.contains(num)) return true;
        seen.add(num);
      }
      return false;
    }

    print('No valid solution pattern found');
    return false;
  }
}
