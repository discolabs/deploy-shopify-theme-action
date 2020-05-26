#!/bin/sh -l

# Configure Theme Kit.
theme configure --store=$INPUT_STORE --password=$INPUT_PASSWORD  --themeid=$INPUT_THEME_ID --dir=$INPUT_PATH

# Fetch the deploy hash from the theme, if it exists and ignoring a file not found error.
theme download assets/deploy_sha.txt || true
LAST_DEPLOY_SHA=$(cat "$INPUT_PATH/assets/deploy_sha.txt" | xargs)

echo "---> Last deploy SHA is ${LAST_DEPLOY_SHA:=empty}"

# If a custom build command and pathspec was defined, see if it should be run.
if [ ! -z "$INPUT_BUILD_COMMAND" ] && [ ! -z "$INPUT_BUILD_PATHSPEC" ]; then
  echo "---> Build command detected: $INPUT_BUILD_COMMAND with pathspec $INPUT_BUILD_PATHSPEC"

  build() {
    echo "---> Building..."
    $INPUT_BUILD_COMMAND
    echo "---> Build completed"
  }

  if [ ! -z "$LAST_DEPLOY_SHA" ]; then
    # Get a list of build source files that have changed in our repository since the last deploy.
    CHANGED_BUILD_FILES=$(git diff "$LAST_DEPLOY_SHA..$GITHUB_SHA" --name-only -- $INPUT_BUILD_PATHSPEC)

    echo "---> Changed build files since last deploy: ${CHANGED_BUILD_FILES:=none}"

    if [ ! -z "$CHANGED_BUILD_FILES" ]; then
      build
    fi
  else
    build
  fi
fi

# Check if we could retrieve a deploy SHA.
if [ ! -z "$LAST_DEPLOY_SHA" ]; then
  # Get a list of files that have changed in our Shopify theme since the last deploy.
  CHANGED_FILES=$(git diff "$LAST_DEPLOY_SHA..$GITHUB_SHA" --name-only -- $INPUT_PATH/{assets,config,layout,locales,sections,snippets,templates})

  echo "---> Changed theme files since last deploy: ${CHANGED_THEME_FILES:=none}"

  if [ ! -z "$CHANGED_FILES" ]; then
    CHANGED_THEME_FILES=$(echo "$CHANGED_FILES" | xargs realpath --relative-to=$INPUT_PATH)

    # Deploy only those changes, if they exist.
    if [ ! -z "$CHANGED_THEME_FILES" ]; then
      echo "---> Deploying only changed files..."
      echo "$CHANGED_THEME_FILES" | xargs theme deploy $INPUT_ADDITIONAL_ARGS
      echo "---> Deploy completed"
    fi
  fi
else
  # Deploy all files.
  echo "---> Deploying all files..."
  theme deploy $INPUT_ADDITIONAL_ARGS
  echo "---> Deploy completed"
fi

# Upload the latest deploy SHA.
echo "---> Updating last deploy SHA to $GITHUB_SHA..."
echo $GITHUB_SHA > "$INPUT_PATH/assets/deploy_sha.txt"
theme deploy assets/deploy_sha.txt
echo "---> Update completed"