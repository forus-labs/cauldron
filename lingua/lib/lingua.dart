library lingua;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'file:///C:/Users/Matthias/Documents/NetBeansProjects/cauldron/lingua/lib/src/old/generator.dart';

Builder build(BuilderOptions options) => SharedPartBuilder([LanguageGenerator(options.config)], 'lingua');
