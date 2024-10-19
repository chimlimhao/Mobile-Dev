enum Skill { FLUTTER, DART, OTHER }

Map<Skill, double> skillsBonus = {
  Skill.FLUTTER: 5000,
  Skill.DART: 3000,
  Skill.OTHER: 1000
};

class Address {
  String street;
  String city;
  int zipCode;

  Address(this.street, this.city, this.zipCode);
}

class Employee {
  final String _name;
  final String _position;
  final double _baseSalary;
  List<Skill> _skills = [];
  Address _address;
  final int _yearOfExperience;

  Employee(this._name, this._position, this._baseSalary, this._address,
      this._skills, this._yearOfExperience);
  Employee.mobileDeveloper(String name, String position, Address address,
      double baseSalary, List<Skill> skills, int yearOfExperience)
      : this(name, position, baseSalary, address, skills, yearOfExperience);
  Employee.backendDeveloper(String name, String position, Address address,
      double baseSalary, List<Skill> skills, int yearOfExperience)
      : this(name, position, baseSalary, address, skills, yearOfExperience);

  String get name => _name;
  String get position => _position;
  double get baseSalary => _baseSalary;
  List<Skill> get skills => _skills.map((skill) => skill).toList();
  Address get address => _address;
  int get yearOfExperience => _yearOfExperience;

  double totalSalary() {
    double totalSalary = baseSalary;
    if (yearOfExperience >= 0) {
      totalSalary += yearOfExperience * 2000;
      // print(totalSalary);
      skills.forEach((skill) => totalSalary += skillsBonus[skill] ?? 1000);
    }
    return totalSalary;
  }

  String formatSkills() {
    return skills.map((skill) => skill.toString().split('.').last).join(', ');
  }

  @override
  String toString() {
    return 'Employee Details:\n'
        '- Position: $position\n'
        '- Year Of Experience: $yearOfExperience\n'
        '- Skills: ${formatSkills()}\n'
        '- Salary: ${totalSalary()}';
  }
}

void main() {
  Address a = Address('St. 01', 'Phnom Penh', 12202);
  // print(address);
  Employee mobileDev = Employee.mobileDeveloper(
      'Limhao', 'Mobile Developer', a, 40000, [Skill.FLUTTER, Skill.DART], 3);
  print(mobileDev);
  Employee backendDev = Employee.backendDeveloper(
      'Chim', 'Backend-Developer', a, 40000, [Skill.DART], 1);
  print(backendDev);
}
