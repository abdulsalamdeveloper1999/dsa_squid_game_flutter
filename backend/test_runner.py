def run_python_tests(code):
    # Test cases
    test_cases = [
        {'input': [1, 2, 3, 1], 'expected': True},
        {'input': [1, 2, 3, 4], 'expected': False},
        {'input': [1, 1, 1, 3, 3, 4, 3, 2, 4, 2], 'expected': True},
        {'input': [], 'expected': False},
        {'input': [1], 'expected': False},
        {'input': [1, 1], 'expected': True},
    ]
    
    try:
        # Create namespace and execute the code
        namespace = {}
        exec(code, namespace)
        
        # Get the function
        containsDuplicate = namespace.get('containsDuplicate')
        if not containsDuplicate:
            return False, "Function 'containsDuplicate' not found"
            
        # Run all test cases
        for i, test in enumerate(test_cases):
            result = containsDuplicate(test['input'])
            if result != test['expected']:
                return False, f"Test case {i + 1} failed: input={test['input']}, expected={test['expected']}, got={result}"
                
        return True, "All test cases passed!"
        
    except Exception as e:
        return False, f"Error: {str(e)}" 