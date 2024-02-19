#! /bin/bash
set -e

[[ $0 != 'tool/refresh.sh' ]] && echo "Must be run as tool/refresh.sh" && exit

dart pub get

zoneinfo=$(pwd)/tool/timezone/zoneinfo
temp=$(mktemp -d -t tzdata-XXXXXXXXXX)

pushd "$temp" > /dev/null

echo "Fetching latest database..."
curl https://data.iana.org/time-zones/tzdata-latest.tar.gz | tar -zx

echo "Compiling into zoneinfo files..."
rm -r "$zoneinfo"
mkdir "$zoneinfo"
zic -d "$zoneinfo" -b fat africa antarctica asia australasia etcetera europe \
                northamerica southamerica backward factory

popd > /dev/null

rm -r $temp

echo "Generating Dart code from zoneinfo files..."
dart run tool/timezone/generate_timezones.dart

echo "Generating Dart code from Windows timezone mappings..."
dart run tool/generate_windows_zones.dart
