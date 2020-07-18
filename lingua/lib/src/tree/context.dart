import 'dart:ui';

class Context {

  final Locale locale;
  final String section;
  final String lexeme;

  const Context(this.locale, this.section, this.lexeme);

  const Context.root(Locale locale): this(locale, '', '');


  Context descend(String key) => Context(locale, section.isNotEmpty ? '$section.$lexeme' : lexeme, key);


  String get location => '$_path in ${locale.toLanguageTag()}.yaml';

  String get _path {
    if (section.isNotEmpty && lexeme.isNotEmpty) {
      return '"$section.$lexeme"';

    } else if (section.isEmpty && lexeme.isNotEmpty) {
      return '"$lexeme"';

    } else {
      return 'root';
    }
  }

}