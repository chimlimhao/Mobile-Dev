void main() {
  // List of student scores
  List<int> scores = [45, 67, 82, 49, 51, 78, 92, 30];

  // You code

  // print(scores.length);
  List<int> passed_student = [];
  for (int i = 0; i < scores.length; i++){
    if (scores[i] > 50){
      passed_student.add(scores[i]);
    }
  }
  print(passed_student);
  var num_student_pass = passed_student.length;
  print('$num_student_pass students passed');
}