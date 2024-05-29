CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

# Verify the student's file submission
cd student-submission
if [ ! -f "ListExamples.java" ]; then
    echo "Error: ListExamples.java not found. Please submit the correct Java file."
    exit 1
fi

# Copy the student's Java file and any necessary test files to the grading area
cp ListExamples.java ../grading-area/
cp TestListExamples.java ../grading-area/

# Move to the grading area to compile and run tests
cd ../grading-area/

# Compile the student's code and the tests
javac -cp "$CPATH" ListExamples.java TestListExamples.java 2>&1 | tee compile.log

# Run the tests
java -cp "$CPATH" org.junit.runner.JUnitCore TestListExamples > results.log 2>&1

# Check the output of the tests to determine the grade
if grep -q "FAILURES!!!" results.log; then
    echo "Some tests did not pass. Please review the test results."
    grep "FAILURES!!!" results.log
else
    echo "All tests passed. Excellent work!"
fi

# Draw a picture/take notes on the directory structure that's set up after
# getting to this point
ls -R
