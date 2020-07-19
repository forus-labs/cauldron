library lingua;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:lingua/src/generator.dart';

Builder build(BuilderOptions options) => SharedPartBuilder([LanguageGenerator(options.config)], 'lingua');
