#!/bin/bash
set -e

if [ "$1" == "base" ]; then
    # Run existing tests only
    pytest tests/test_data/test_data_module.py::test_different_split_ratios -v
elif [ "$1" == "new" ]; then
    # Run only new tests
    pytest tests/test_data/test_preprocessing_d2.py -v
else
    echo "Usage: ./test.sh [base|new]"
    exit 1
fi

