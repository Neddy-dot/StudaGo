class Student {
  final String id;
  final String name;
  final String grade;
  final String parentId;

  const Student({
    required this.id,
    required this.name,
    required this.grade,
    required this.parentId,
  });
}

class MockDatabase {
  static const List<Student> students = [
    Student(id: 'STU-9981', name: 'John Doe', grade: 'Class 3A', parentId: 'PAR-001'),
    Student(id: 'STU-1234', name: 'Jane Smith', grade: 'Class 4B', parentId: 'PAR-002'),
    Student(id: 'STU-5678', name: 'Alice Johnson', grade: 'Class 2C', parentId: 'PAR-003'),
    Student(id: 'STU-0000', name: 'Test Student', grade: 'Class 1A', parentId: 'PAR-000'),
  ];

  static Student? getStudentById(String id) {
    try {
      return students.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
}
