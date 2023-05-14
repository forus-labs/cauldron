# 2.7.0 (13/05/2023)
This update focuses on lint rules introduce in Dart 3.

- Add `deprecated_member_use_from_same_package`
- Add `type_literal_in_constant_pattern`
- Add `unnecessary_breaks`
- Add `unnecessary_nullable_for_final_variable_declarations`
- Remove `enable_null_safety`
- Remove ignored `invariant_booleans`
- Remove ignored `prefer_equal_for_default_values`

# 2.6.0+1 (26/01/2023)
Fix formatting in `analysis_options.yaml`.

# 2.6.0 (26/01/2023)
This update focuses on lint rules introduced in Dart 2.19.

-Add `combinators_ordering`
-Add `collection_methods_unrelated_type`
-Add `dangling_library_doc_comments`
-Add `enable_null_safety`
-Add `implicit_call_tearoffs`
-Add `library_annotations`
-Add `unnecessary_library_directive`
-Add `use_string_in_part_of_directives`
- Remove deprecated `avoid_returning_null_for_future` 
- Remove deprecated `always_require_non_null_named_parameters`
- Remove deprecated `avoid_returning_null`
- Remove deprecated `prefer_equal_for_default_values`

## 2.5.3 (01/12/2022)
This update removes `invariant_booleans`.

- Remove `invariant_booleans`

## 2.5.2 (05/09/2022)
This update removes `prefer_int_literals`, see https://github.com/dart-lang/linter/issues/3657.

- Remove `prefer_int_literals`

## 2.5.1 (05/09/2022)
This update adds `depend_on_referenced_packages` which was accidentally omitted from the previous release.

- Add `depend_on_referenced_packages`

## 2.5.0 (01/09/2022)
This update focuses on lint rules introduced in Dart 2.18.

- Add `unnecessary_null_aware_operator_on_extension_on_nullable`
- Add `unnecessary_to_list_in_spreads`

## 2.4.0 (12/05/2022)
This update focuses on lint rules introduced in Dart 2.17.

- Add `cast_nullable_to_non_nullable`
- Add `null_check_on_nullable_type_parameter`
- Add `use_enums`
- Add `use_super_parameters`

## 2.3.2 (04/02/2022)
- Re-add accidentally deleted rule `no_leading_underscores_for_local_identifiers`

## 2.3.1 (04/02/2022)
- Remove `use_key_in_widget_constructors`

## 2.3.0 (04/02/2022)
This update focuses on lint rules introduced in Dart 2.16.

- Add `avoid_final_parameters`
- Add `conditional_uri_does_not_exist`
- Add `no_leading_underscores_for_library_prefixes`
- Add `no_leading_underscores_for_local_identifiers`
- Add `secure_pubspec_urls`
- Add `unnecessary_late`
- Add `use_if_null_to_convert_nulls_to_bools`
- Add `use_named_constants`
- Add `use_test_throws_matchers`

## 2.2.1 (12/01/2022)

- Remove `sort_unnamed_constructors_first`

## 2.2.0 (09/12/2021)
This update focuses on lint rules introduced in Dart 2.15.

- Add `avoid_dynamic_calls`
- Add `avoid_multiple_declarations_per_line`
- Add `deprecated_consistency`
- Add `eol_at_end_of_file`
- Add `library_private_types_in_public_api`
- Add `noop_primitive_operations`
- Add `prefer_null_aware_method_calls`
- Add `unnecessary_constructor_name`

- Remove `sort_unnamed_constructors_first`
## 2.1.2 - (10/09/2021)
This update fixes a few issues.

- Remove `depend_on_referenced_packages`

## 2.1.1 - (10/09/2021)
This update fixes a few issues.

- Remove `directives_ordering` - this rule doesn't fit our own style guide on import ordering

## 2.1.0 - (10/09/2021)
This update focuses on supporting lint rules introduced in Dart 2.14

- Add `depend_on_referenced_packages`

## 2.0.1 - (27/07/2021)

- Remove `avoid_classes_with_only_static_members` - while in theory a great idea, it is impractical due to IDEs not automatically
  handling `import something as x` well.

## 2.0.0 - The Return of the Flint (25/06/2021)

We have returned, and we're finally updating Flint. Due to changes with our git workflow, we have merged the `.dev` and `.stable`
variations of the Dart & Flutter `analysis_options.yaml`.

- Add `package:flint/analysis_options.dart.yaml`
- Add `package:flint/analysis_options.flutter.yaml`
- Remove `package:flint/analysis_options.dart.dev.yaml`
- Remove `package:flint/analysis_options.dart.stable.yaml`
- Remove `package:flint/analysis_options.flutter.dev.yaml`
- Remove `package:flint/analysis_options.flutter.stable.yaml`

## 1.3.1 - I messed up (05/10/2020)

Today I learnt that semantic version in Dart is broken. This update removes some lint rules that were
mistakely assumed to have been released in 2.10.0.

- Remove `avoid_type_to_string`

## 1.3.0 - I ran out of Flint puns (04/10/2020)
This update adds rules introduced in Dart 2.10.0.

- Add `always_use_package_imports`
- Add `avoid_type_to_string`
- Add `do_not_use_environment`

## 1.2.0 - I'm running out of Flint puns (14/08/2020)
This update adds rules introduced in Dart 2.9.0.

- Add `exhaustive_cases`
- Add `sized_box_for_whitespac`
- Add `use_is_even_rather_than_modulo`

## 1.1.1 - Maybe one day I'll remember to update the README.md (27/07/20)
This update updates the outdated readme for the latest update.

## 1.1.0 - Flint City (26/07/2020)
This update focuses on improving the update tool and removing versioned `analysis_options` files.

- Add `lib/analysis_options.*.yaml`
- Add `tool/**`
- Add `use_raw_strings`
- Add `avoid_escaping_inner_quotes`
- Add `avoid_redundant_argument_values`
- Add `leading_newlines_in_multiline_strings`
- Add `missing_whitespace_between_adjacent_strings`
- Add `no_runtimeType_toString`
- Add `unnecessary_raw_strings`
- Add `unnecessary_string_escapes`
- Add `unnecessary_string_interpolations`
- Add `use_raw_strings`
- Remove `auto_updater/**` - the update tool was rewritten and moved to `tool/**`
- Remove `lib/dart/dev/**`
- Remove `lib/dart/stable/**`
- Remove `lib/flutter/dev/**`
- Remove `lib/flutter/stable/**`
- Remove `avoid_annotating_with_dynamic`

## 1.0.7 Fixity Fix - (13/06/2020)
- Fix analysis_options not getting exported

## 1.0.6 Addity Add - (13/06/2020)
- Add library directive

## 1.0.5 Bumpity Bump - (12/06/2020)
- Change minimum Dart version from `2.7.0` to `2.8.4`
- Move Flint to Cauldron

## 1.0.4 - Moar Fixes (25/01/2020)

- Fix `parameter_assignment` being enabled
- Fix `use_to_and_as_if_applicable` being ignored

## 1.0.3 - Successive Refinement (25/01/2020)

- Fix `avoid_renaming_method_parameters` being enabled
- Fix `diagnostic_describe_all_properties` being enabled

## 1.0.2 - Third's the charm? (25/01/2020)

- Add missing `flint.dart` file

## 1.0.1 - I swear it won't happen again (25/01/2020)

- Add example
- Fix error in `generation.dart`
- Fix `package_api_docs` being enabled in dev branches
- Fix `use_full_hex_values_for_flutter_colors` being enabled in dart branches
- Fix duplicate `public_member_api_docs` entry in `dart/dev/analysis_options.yaml`
- Remove `lib/flint.dart`

## 1.0.0 - Initial Launch! 🚀 (25/01/2020)

- Add `analysis_options.yaml` for Dart & Flutter
- Add auto-update tool for `analysis_option.yaml`
