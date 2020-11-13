String taskNameValidator(String value) {
  if (value.isEmpty) {
    return 'Eingabe darf nicht leer sein';
  } else if (value.length < 3) {
    return 'Eingabe muss mindestens 3 Zeichen lang sein';
  }
  return null;
}
