import 'dart:ui';

class Context {

  final Locale locale;
  final String section;
  final String key;

  const Context(this.locale, this.section, this.key);

  const Context.root(Locale locale): this(locale, '', '');


  Context descend(String key) => Context(locale, section.isNotEmpty ? '$section.${this.key}' : this.key, key);


  String get location => '$_path in ${locale.toLanguageTag()}.yaml';

  String get _path {
    if (section.isNotEmpty && key.isNotEmpty) {
      return '"$section.$key"';

    } else if (section.isEmpty && key.isNotEmpty) {
      return '"$key"';

    } else {
      return 'root';
    }
  }

}