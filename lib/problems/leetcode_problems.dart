class LeetCodeProblem {
  final String title;
  final String description;
  final String exampleInput;
  final String exampleOutput;
  final String startingCode;
  final String solution;

  LeetCodeProblem({
    required this.title,
    required this.description,
    required this.exampleInput,
    required this.exampleOutput,
    required this.startingCode,
    required this.solution,
  });
}

class LeetCodeProblems {
  static final containsDuplicate = LeetCodeProblem(
    title: "Contains Duplicate",
    description: """
Given an integer array nums, return true if any value appears at least twice in the array, and return false if every element is distinct.
    """,
    exampleInput: """
Input: nums = [1,2,3,1]
Input: nums = [1,2,3,4]
Input: nums = [1,1,1,3,3,4,3,2,4,2]
    """,
    exampleOutput: """
Output: true
Output: false
Output: true
    """,
    startingCode: """
def containsDuplicate(nums):
    # Write your solution here
    pass
    """,
    solution: """
def containsDuplicate(nums):
    seen = set()
    for num in nums:
        if num in seen:
            return True
        seen.add(num)
    return False
    """,
  );
}
