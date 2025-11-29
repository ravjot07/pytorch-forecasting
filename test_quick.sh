#!/bin/bash
# Quick test script that validates syntax without running full tests
set -e

echo "=== Testing test.sh script syntax ==="
bash -n test.sh && echo "✓ test.sh syntax is valid"

echo ""
echo "=== Testing test file syntax ==="
python3 -m py_compile tests/test_data/test_preprocessing_d2.py && echo "✓ test_preprocessing_d2.py syntax is valid"

echo ""
echo "=== Checking test functions ==="
grep -c "def test_" tests/test_data/test_preprocessing_d2.py | xargs -I {} echo "✓ Found {} test functions"

echo ""
echo "=== Checking imports ==="
python3 << 'EOF'
import ast
import sys

try:
    with open('tests/test_data/test_preprocessing_d2.py', 'r') as f:
        tree = ast.parse(f.read())
    
    imports = []
    for node in ast.walk(tree):
        if isinstance(node, ast.Import):
            for alias in node.names:
                imports.append(alias.name)
        elif isinstance(node, ast.ImportFrom):
            module = node.module or ''
            for alias in node.names:
                imports.append(f"{module}.{alias.name}")
    
    print(f"✓ Found {len(imports)} imports")
    print("✓ All imports are syntactically valid")
except SyntaxError as e:
    print(f"✗ Syntax error: {e}")
    sys.exit(1)
EOF

echo ""
echo "=== Summary ==="
echo "✓ All static checks passed"
echo "✓ Test file is ready"
echo ""
echo "Note: To run actual tests, install dependencies:"
echo "  source venv/bin/activate && pip install -e '.[dev]'"
echo "Then run: ./test.sh base  or  ./test.sh new"

