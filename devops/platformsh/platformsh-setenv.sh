#!/bin/bash

# Generate individual .env for each platform branch by using JSON enabled project var: ENV_VARS_<uppercase branch name>
# NOTE: if there's SHOPWARE_URL within the JSON, it will be overwritten by .env.local.php's logic for dynamic db pass

# Example of ENV_VARS_MAIN value:
#  {
#    "SHOPWARE_URL": "<storefront domain for main branch - production>",
#    "APP_ENV": "prod",
#    "APP_NAME": "<project_name>",
#    "APP_SECRET": "<my_secret>",
#    "APP_DEBUG": "0",
#    "LOCK_DSN": "flock"
#  }

cd $SW_APP_DIR || return

# Assuming $PLATFORM_BRANCH is already set and could be any valid branch name
branch=$PLATFORM_BRANCH

# Convert the branch name to uppercase and prepend with ENV_VARS_
env_var_name="ENV_VARS_$(echo $branch | tr '[:lower:]' '[:upper:]')"

# Decode and parse the PLATFORM_VARIABLES, using jq to extract the specific branch config
env_vars=$(echo $PLATFORM_VARIABLES | base64 --decode | jq -r --arg KEY "$env_var_name" '.[$KEY]')

# Now, create or overwrite the var/platformsh_tmp/.env file
echo "# Generated var/platformsh_tmp/.env file for the $branch branch" > $SW_APP_DIR/var/platformsh_tmp/.env

# Loop through keys and values and write them to the var/platformsh_tmp/.env file
echo $env_vars | jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' >> var/platformsh_tmp/.env

# Verify what's been written to var/platformsh_tmp/.env, and that symbolic link works
cat .env
