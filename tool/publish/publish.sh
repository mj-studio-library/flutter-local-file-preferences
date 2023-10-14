fail() {
  echo "ERROR: ${1}"
  exit 1
}

tag=$1

if [[ -z $tag ]]; then
  fail 'arg fail'
fi

flutter pub get
if [[ $? -ne 0 ]]; then
  fail 'fail'
fi
flutter pub run tool/publish/check_version.dart $tag
if [[ $? -ne 0 ]]; then
  fail 'fail'
fi
flutter analyze
if [[ $? -ne 0 ]]; then
  fail 'fail'
fi
dart format --set-exit-if-changed .
if [[ $? -ne 0 ]]; then
  fail 'fail'
fi
flutter pub publish --force
if [[ $? -ne 0 ]]; then
  fail 'fail'
fi
git tag $tag
git push origin $tag
git add .
git commit -m "[release] $tag" --allow-empty
git push

cd doc && yarn deploy