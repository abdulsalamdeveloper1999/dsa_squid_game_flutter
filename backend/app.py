from flask import Flask, request, jsonify
import ast
import sys
from io import StringIO

app = Flask(__name__)

def run_test_cases(code, test_cases):
    try:
        # Clean up the code by removing extra whitespace and normalizing line endings
        code = '\n'.join(line.strip() for line in code.splitlines())
        
        # Create a namespace for the function
        namespace = {}
        
        # Execute the code in the namespace
        exec(code, namespace)
        
        # Get the function
        containsDuplicate = namespace.get('containsDuplicate')
        if not containsDuplicate:
            return False
            
        # Run all test cases
        for test in test_cases:
            try:
                result = containsDuplicate(test['input'])
                # Convert Python bool to match test case bool
                result = bool(result)
                if result != test['expected']:
                    return False
            except Exception as e:
                print(f"Test case error: {e}")
                return False
                
        return True
    except Exception as e:
        print(f"Execution error: {e}")
        return False

def check_structure(code):
    """Check if code has required elements: function definition, loop, set usage"""
    try:
        tree = ast.parse(code)
        has_function = False
        has_loop = False
        has_set = False
        
        for node in ast.walk(tree):
            if isinstance(node, ast.FunctionDef) and node.name == 'containsDuplicate':
                has_function = True
            elif isinstance(node, (ast.For, ast.While)):
                has_loop = True
            elif isinstance(node, ast.Call):
                if getattr(node.func, 'id', '') == 'set':
                    has_set = True
                    
        return has_function and has_loop and has_set
    except Exception as e:
        print(f"Structure check error: {e}")
        return False

@app.route('/check', methods=['POST'])
def check_solution():
    data = request.json
    user_code = data['user_code']
    test_cases = data['test_cases']
    
    # Check code structure
    if not check_structure(user_code):
        return jsonify({'is_correct': False, 'message': 'Missing required elements'})
    
    # Run test cases
    if not run_test_cases(user_code, test_cases):
        return jsonify({'is_correct': False, 'message': 'Failed test cases'})
    
    return jsonify({'is_correct': True})

if __name__ == '__main__':
    app.run() 