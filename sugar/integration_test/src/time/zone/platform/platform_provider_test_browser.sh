CURRENT_TIMEZONE=$(realpath /etc/localtime)
CURRENT_TIMEZONE=${CURRENT_TIMEZONE#"zoneinfo/"}

sudo timedatectl set-timezone "Asia/Tokyo"

echo "Current timezone: $CURRENT_TIMEZONE"
echo "Test timezone: Asia/Tokyo"


TEST_NAME="defaultPlatformTimezoneProvider() return current timezone"
dart run --pause-isolates-on-exit --disable-service-auth-codes --enable-vm-service=8181 test ./integration_test -p "chrome" --plain-name="$TEST_NAME" &
dart run coverage:collect_coverage --wait-paused --uri=http://127.0.0.1:8181/ -o coverage/coverage.json --resume-isolates --scope-output=sugar

dart run --pause-isolates-on-exit --disable-service-auth-codes --enable-vm-service=8181 test ./integration_test -p "firefox" --plain-name="$TEST_NAME" &
dart run coverage:collect_coverage --wait-paused --uri=http://127.0.0.1:8181/ -o coverage/coverage.json --resume-isolates --scope-output=sugar


dart run coverage:format_coverage --packages=.dart_tool/package_config.json --lcov -i coverage/coverage.json -o coverage/lcov.info
sudo systemsetup -settimezone "$CURRENT_TIMEZONE"
