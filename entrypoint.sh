#!/bin/sh -l

# Configure Theme Kit.
theme configure --store=$INPUT_STORE --password=$INPUT_PASSWORD  --themeid=$INPUT_THEME_ID --dir=$INPUT_PATH

# Fetch the deploy hash from the theme, if it exists and ignoring a file not found error.
theme download assets/deploy || true
LAST_DEPLOY_SHA=$(cat "$INPUT_PATH/assets/deploy")

echo "---> LAST_DEPLOY_SHA is $LAST_DEPLOY_SHA"

# Check if we could retrieve a deploy SHA.
if [ ! -z "$LAST_DEPLOY_SHA" ]; then
  # Get a list of files that have changed in our Shopify theme since the last deploy.
  CHANGED_FILES=$(git diff "$LAST_DEPLOY_SHA..$GITHUB_SHA" --name-only)

  echo "---> CHANGED_FILES is $CHANGED_FILES"

  # Deploy only those changes, if they exist.
  if [ ! -z "$CHANGED_FILES" ]; then
    echo "$CHANGED_FILES" | xargs theme deploy $INPUT_ADDITIONAL_ARGS
  fi
else
  # Deploy all files.
  theme deploy $INPUT_ADDITIONAL_ARGS
fi

# Upload the latest deploy SHA.
echo $GITHUB_SHA > "$INPUT_PATH/assets/deploy"
theme deploy assets/deploy