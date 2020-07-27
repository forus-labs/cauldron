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
