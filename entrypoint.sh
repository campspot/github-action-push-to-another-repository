#!/bin/sh -l

set -e  # if a command fails it stops the execution
set -u  # script fails if trying to access to an undefined variable

echo "[+] Action start"
SOURCE_DIRECTORY="$1"
DESTINATION_DIRECTORY="$2"
DESTINATION_GITHUB_USERNAME="$3"
DESTINATION_REPOSITORY_NAME="$4"
USER_EMAIL="$5"
DESTINATION_REPOSITORY_USERNAME="$6"
TARGET_BRANCH="$7"
COMMIT_MESSAGE="$8"

echo "[+] Print Destination Directory $DESTINATION_DIRECTORY"

if [ -z "$DESTINATION_REPOSITORY_USERNAME" ]
then
  DESTINATION_REPOSITORY_USERNAME="$DESTINATION_GITHUB_USERNAME"
fi

CLONE_DIR=$(mktemp -d)

echo "[+] Cloning destination git repository $DESTINATION_REPOSITORY_NAME"
# Setup git
git config --global user.email "$USER_EMAIL"
git config --global user.name "$DESTINATION_GITHUB_USERNAME"
git clone --single-branch --branch "$TARGET_BRANCH" "https://$API_TOKEN_GITHUB@github.com/$DESTINATION_REPOSITORY_USERNAME/$DESTINATION_REPOSITORY_NAME.git" "$CLONE_DIR"
ls -la "$CLONE_DIR"

echo "[+] Deleting files from $DESTINATION_DIRECTORY in git repo $DESTINATION_REPOSITORY_NAME"
rm -rfv "$CLONE_DIR/$DESTINATION_DIRECTORY"/*
echo "[+] Veryfing that the directory that will be pushed is EMPTY"
ls -la "$CLONE_DIR/$DESTINATION_DIRECTORY"

echo "[+] Copying contents of source repository folder $SOURCE_DIRECTORY to folder $DESTINATION_DIRECTORY in git repo $DESTINATION_REPOSITORY_NAME"
cp -ra "$SOURCE_DIRECTORY"/. "$CLONE_DIR/$DESTINATION_DIRECTORY"
cd "$CLONE_DIR/$DESTINATION_DIRECTORY"

echo "[+] Files that will be pushed"
ls -la

echo "[+] Adding git commit"

ORIGIN_COMMIT="https://github.com/$GITHUB_REPOSITORY/commit/$GITHUB_SHA"
COMMIT_MESSAGE="${COMMIT_MESSAGE/ORIGIN_COMMIT/$ORIGIN_COMMIT}"

git add .
git status

# git diff-index : to avoid doing the git commit failing if there are no changes to be commit
git diff-index --quiet HEAD || git commit --message "$COMMIT_MESSAGE"

echo "[+] Pushing git commit"
# --set-upstream: sets de branch when pushing to a branch that does not exist
git push origin --set-upstream "$TARGET_BRANCH"
