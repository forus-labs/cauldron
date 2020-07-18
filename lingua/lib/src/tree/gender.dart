enum Gender {
  male, female, others, error

}

extension Genders on Gender {

  static Gender from(String gender) {
    switch (gender) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      case r'$others':
        return Gender.others;
      default:
        return null;
    }
  }

}