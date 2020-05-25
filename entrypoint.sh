#!/bin/sh -l

theme deploy --store=$INPUT_STORE --password=$INPUT_PASSWORD  --themeid=$INPUT_THEME_ID --dir=$INPUT_PATH $INPUT_ADDITIONAL_ARGS
