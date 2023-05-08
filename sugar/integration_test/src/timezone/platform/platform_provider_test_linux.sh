CURRENT_TIMEZONE=$(realpath /etc/localtime)
CURRENT_TIMEZONE=${CURRENT_TIMEZONE#"zoneinfo/"}

sudo timedatectl set-timezone "Asia/Tokyo"

echo "Current timezone: $CURRENT_TIMEZONE"
echo "Test timezone: Asia/Tokyo"


TEST_NAME="defaultPlatformTimezoneProvider() return current timezone"
dart run --pause-isolates-on-exit --disable-service-auth-codes --enable-vm-service=8181 test ./integration_test --plain-name="$TEST_NAME" &
dart run coverage:collect_coverage --wait-paused --uri=http://127.0.0.1:8181/ -o coverage/coverage.json --resume-isolates --scope-output=sugar

TEST_NAME="defaultPlatformTimezoneProvider() known TZ environment variable"
export TZ="Mexico/BajaSur"
dart run --pause-isolates-on-exit --disable-service-auth-codes --enable-vm-service=8181 test ./integration_test --plain-name="$TEST_NAME" &
dart run coverage:collect_coverage --wait-paused --uri=http://127.0.0.1:8181/ -o coverage/coverage.json --resume-isolates --scope-output=sugar
unset TZ

TEST_NAME="defaultPlatformTimezoneProvider() unknown TZ environment variable"
export TZ='invalid'
dart run --pause-isolates-on-exit --disable-service-auth-codes --enable-vm-service=8181 test ./integration_test --plain-name="$TEST_NAME" &
dart run coverage:collect_coverage --wait-paused --uri=http://127.0.0.1:8181/ -o coverage/coverage.json --resume-isolates --scope-output=sugar
unset TZ


dart run coverage:format_coverage --packages=.dart_tool/package_config.json --lcov -i coverage/coverage.json -o coverage/lcov.info
sudo systemsetup -settimezone "$CURRENT_TIMEZONE"
