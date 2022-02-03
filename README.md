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
git repository and edit them to get started. Or you can get inspiration if you're trying to migrate an existing
Terraform project to use this module. A base configuration requires at least:

* a configured core module

## Bootstrap

Make sure you have configured at least a base configuration as described above.

## Configuration
### module core

```hcl

```

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
