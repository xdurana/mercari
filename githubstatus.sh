#! /bin/sh

# Result of the CI
BUILD_URL="http://ci.example.com/user/repo/build/sha"

testcommand=$1
gitroot=`git rev-parse --show-cdup`
repo=`grep url $gitroot.git/config | sed -E "s/.*:(.*)\.git/\\1/g"`
echo "Repo is $repo"

python githubstatus.py --sha $GIT_COMMIT --status pending --repo $repo --url $BUILD_URL

$testcommand && buildstatus=success || buildstatus=failure

python githubstatus.py --sha $GIT_COMMIT --status $buildstatus --repo $repo --url $BUILD_URL
if [ "$buildstatus" = "failure" ]; then
    exit 1
fi
