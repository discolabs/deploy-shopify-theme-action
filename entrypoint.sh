#!/bin/sh -l

theme configure --store=$INPUT_STORE --password=$INPUT_PASSWORD  --themeid=$INPUT_THEME_ID --dir=$INPUT_PATH

theme deploy $INPUT_ADDITIONAL_ARGS

echo $GITHUB_SHA > "$INPUT_PATH/assets/deploy"
theme deploy $INPUT_ADDITIONAL_ARGS "$INPUT_PATH/assets/deploy"