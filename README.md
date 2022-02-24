# What is this

This repository contains a **highly opinionated** Terraform module for configuring Google Cloud. After finding myself
implementing the same kind of basic configuration of Google Cloud environments multiple times in a row I decided to
abstract it all into a separate module for easier reuse.

# BIG FAT WARNINGS

* If you want to use this module, you have to be aware that it will take over most of your Google Cloud configuration, 
  including organization policies, folder structure, (some) project naming, structuring, ...
* This module implements things that are considered best practice, either in general or according to Google Cloud 
  Documentation, as well as personal views by the author.
* While not impossible (and it has been done a few times), importing an existing Google Cloud environment will take 
  some effort and knowledge of the way Terraform works. This documentation makes no effort to guide you in this, you're 
  on your own.
* While care has been taken not to break (or worse: remove) anything, it is possible something goes wrong so always 
  carefully examine the Terraform changes and do not blindly trust this module.
* Use this module at your own risk. The author takes no responsibility if by using this module you lose or expose data
  to third parties. By using this module you explicitly agree that no claims can be made to the author if this occurs. 

# Dependencies

* Terraform (obviously)
* This module uses both the stable and (often) the beta Terraform google provider

# Principles

* Users get direct read-only access, so they can use Cloud console / gcloud command to inspect infrastructure
  * Excludes view access for objects in storage buckets but can be granted explicitly
* Users get read-write access only through service account impersonation
* There is a core project which contains
  * All the service accounts
  * Cloud Storage buckets for Terraform state files for projects
* Automatic network creation is disabled for all projects
* Automatic service account creation is disabled for all projects
* Except for organizational policies, all policies will be cleared / overwritten by what is configured in Terraform
  * This means that policies need to be persisted in Terraform scripts (hurray!)
  * For organizational policies the safer approach of just adding to existing policies is taken
  * This means that you can't unintentionally completely lock yourself out of your organization
  * This also means that you should review the permissions on organizational level periodically
* Unless specifically allowed, permissions do not allow service account management to prevent self-elevation
* All storage buckets are DNS namespaced to prevent collisions and increase security

# Usage

While it is possible to use the main branch of this repository, it is advised to lock your infrastructure to tagged
releases. Whenever you upgrade to a new tag you should check [migration.md](migration.md) if there are any state
migrations that need to be performed.

## Base configuration

In [skeleton](skeleton) you can find the bare minimum configuration. You can copy the files in this directory to a new
git repository and edit them to get started. They are designed to live in a directory on the same level as this repo.

Or you can get inspiration if you're trying to migrate an existing Terraform project to use this module. The rest of
this document presumes you are starting from an empty account with the skeleton configuration. If not, you can use this
document as a guideline for importing existing resources.

To be able to use this repository, you will need:

- an organization
- a superuser GCP account (advised to only use for bootstrapping and occasional manual fixes) 
  - with necessary access rights on organization level
    - Billing Account User
    - Organization Administrator
    - Organization Role Administrator
    - Folder Admin
    - Project Creator
    - Create Service Accounts
  - who is a verified owner of your domain. You can check it[here](https://www.google.com/webmasters/verification/home).
- an existing billing account
- gcloud SDK installed
- Terraform installed (obviously)

Furthermore, a base configuration requires at least a configured core module. Check [skeleton](skeleton) for an example. 

## Bootstrap

Make sure you have configured at least a base configuration as described above.

Log into the superuser account
```shell
$ gcloud auth application-default login
```

Temporarily comment out the configuration in `providers.tf` and `terraform.tf`.

If you haven't done so yet, make sure you initialize terraform

```shell
$ terraform init
```

Now run a targeted apply, this will only create the absolute minimum necessary to proceed

```shell
$ terraform apply -target=module.core.null_resource.bootstrap
```

This should work with the granted rights on the superuser account. If it fails it is most likely a permission problem,
please report back with a bug report your findings.

You can now uncomment the configuration in `providers.tf` and `terraform.tf`. 

Next, make sure you are logged in with your regular Google account.

```shell
$ gcloud auth application-default login
```

Run terraform init again, it will offer you to migrate the existing local state into the cloud, confirm with yes.

```shell
$ terraform init
Initializing modules...

Initializing the backend...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "gcs" backend. No existing state was found in the newly
  configured "gcs" backend. Do you want to copy this state to the new "gcs"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes
```

Remove the local .tfstate files
```shell
$ rm terraform.tfstate*
```

Try running the targeted apply again, nothing should change.
```shell
$ terraform apply -target=null_resource.bootstrap
```

Add the email of the core service account that was created to the list of verified domain owners 
[here](https://www.google.com/webmasters/verification/home).

Now run a full apply
```shell
terraform apply
```

After the initial project has been set up you might want to strip away some rights on organization level, depending on 
your use case.
- For the superuser account in theory you only need to leave the Organization Administrator permissions so that you 
  always have a way to manually recover Terraform issues in case of emergency. Keep in mind that this permission allows
  anyone with access to the superuser account to elevate the rights of the superuser (or any other user).
- For the organization by default Google allows project and billing account creation by any user that is logged in. You
  might want to remove this since it allows anyone to bypass your infrastructure management.

## Configuration
### module core

```hcl
module "core" {
  source = "../gcloud-base/core"

  organization-id = "<numerical google organization id>"
  unique-id       = "example"
  administrators      = ["user:admin@example.com"]
  billing         = "ABC-123"
  state           = {
    domain   = "example.com"
    location = "EUROPE-WEST1"
  }
}
```

- `organization-id`: get this from the Google Cloud Console
- `unique-id`: a string that is used in naming schemes etc, you can for example use your company name
- `administrators`: a list of administrator accounts, the people that can execute this script
- `billing`: the billing account to use for the core project
- `state`
  - `domain`: the domain name linked to your organization
  - `location`: where data of the core project is hosted

# Contributing

Contributions are welcome in the form of pull requests. They might get rejected if they clash with:
* best practices as defined by Google Cloud documentation
* industry considered best practices
* personal views by the author

If the changes in your PR require state migrations, you need to include the required documentation in 
[migration.md](migration.md).

# License

In order to freely use this module without constraints, everything in this repository is licensed using the MIT license.

# Acknowledgements

Big props to [iDalko](https://www.idalko.com) as most of the ideas in this module (and knowledge of the author) were
formed during DevOps assignments for them.
