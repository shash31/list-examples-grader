CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

files=`find student-submission -name "*.java"`
flag=n

for file in $files
do 
  if [[ -f $file ]] && [[ $file == **/ListExamples.java* ]] 
  then 
    testfile=$file
    flag=found
    break
  fi
done

if [ "$flag" != "found" ]; then
  echo 'ListExamples file not found!'
  exit
else
  echo 'File found!'
fi
# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

cp TestListExamples.java grading-area
cp $testfile grading-area
cp -r lib grading-area
cd grading-area

javac -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar *.java
java -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples > junitresults.txt

compiled=$?

if grep 'FAILURES' junitresults.txt; then
  if [ $compiled!=0 ]; then 
    echo 'Code failed to compile :('
  fi
  echo 'The submission failed the grader.'
  echo '0/1'
else 
  echo 'Congratulations!! The submission passed the test.'
  echo '1/1'
fi 
