# Deploy Shopify Theme

This action deploys a Shopify theme to a Shopify store.

It uses a special file in the target theme (`assets/deploy_sha.txt`) to speed up deploys by only deploying theme files that have changed since the last deploy.

# Usage

<!-- start usage -->
```yaml
- uses: discolabs/deploy-shopify-theme-action@v1
  with:
    # Shopify domain of the store to deploy to, for example 'store.myshopify.com'.
    # This can be hard coded, or stored as a secret. Required.
    #
    # [Learn more about creating and using encrypted secrets](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets)
    # 
    # Required.
    store: ${{ secrets.SHOPIFY_STORE }}

    # API password or token to use when deploying the theme to the Shopify store. The
    # credentials should have permission to write to Shopify themes. This should be 
    # stored as a secret.
    #
    # [Learn more about creating and using encrypted secrets](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets)
    #
    # Required.
    password: ${{ secrets.SHOPIFY_PASSWORD }}

    # The ID of the theme to deploy to. This is generally store as a secret to easily
    # change it if needed.    
    #
    # [Learn more about creating and using encrypted secrets](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets)
    #
    # Required. 
    theme_id: ${{ secrets.SHOPIFY_PASSWORD }}


    # If your repository doesn't have the standard Shopify theme structure located at
    # its root (eg, the theme is stored in a `shopify` subdirectory), the path to the
    # theme should be added here, without starting or ending slashes (eg `shopify`).
    #
    # Optional.
    path: ''

    # Additional arguments to pass to Shopify's Theme Kit when deploying your theme.
    # Most commonly used for specifying particular files to ignore in the deploy, for
    # example '--ignored-file=config/settings_data.json'.
    # 
    # Optional.
    additional_args: ''
```
<!-- end usage -->