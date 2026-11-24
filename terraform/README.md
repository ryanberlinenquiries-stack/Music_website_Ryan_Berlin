# AWS hosting

Private S3 bucket behind CloudFront (Origin Access Control), plus an IAM user
whose access key `.github/workflows/deploy-aws.yml` uses on pushes to `main`.
Lives in the `jarrodfolino` account and keeps its state in that account's
consumer state bucket.

## Apply

```sh
terraform -chdir=terraform init \
  -backend-config="bucket=jarrodfolino-tfstate-478119378221" \
  -backend-config="key=music-website/terraform.tfstate" \
  -backend-config="region=ap-southeast-2"

terraform -chdir=terraform plan
terraform -chdir=terraform apply
```

## Wire up the workflow

```sh
R=ryanberlinenquiries-stack/Music_website_Ryan_Berlin
gh secret set   AWS_ACCESS_KEY_ID              -R $R -b "$(terraform -chdir=terraform output -raw deploy_access_key_id)"
gh secret set   AWS_SECRET_ACCESS_KEY          -R $R -b "$(terraform -chdir=terraform output -raw deploy_secret_access_key)"
gh variable set AWS_S3_BUCKET                  -R $R -b "$(terraform -chdir=terraform output -raw bucket_name)"
gh variable set AWS_CLOUDFRONT_DISTRIBUTION_ID -R $R -b "$(terraform -chdir=terraform output -raw cloudfront_distribution_id)"
gh variable set SITE_URL                       -R $R -b "$(terraform -chdir=terraform output -raw site_url)"
gh variable set AMPLITUDE_API_KEY              -R $R -b "<amplitude project API key>"
```

`SITE_URL` replaces the `__SITE_URL__` placeholder in `index.html`,
`sitemap.xml`, `robots.txt` and `llms.txt` at deploy time. Point it at the custom
domain once there is one.

Rotate the access key with `terraform apply -replace=aws_iam_access_key.deploy`
and re-run the two `gh secret set` lines.

The next push to `main` (or `gh workflow run deploy-aws.yml -R $R`) deploys.
