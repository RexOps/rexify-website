---
title: Get Rex
date: 2020-08-31
---

## CPAN

The recommended way to get Rex is to install it from CPAN into your user account's own Perl environment (managed by e.g. [`local::lib`](https://metacpan.org/pod/local::lib), [Perlbrew](https://perlbrew.pl/) or similar). You can simply use your preferred client, for example:

    $ cpanm Rex

While it's possible to install Rex system-wide from CPAN, for that use case you might be interested in checking out packages for your operating system.

## Package managers

### Official packages

Rex is distributed via package managers for many different operating systems. The [Repology page of Rex](https://repology.org/project/rex/versions) is an up-to-date list of available Rex packages.

We encourage you to help those package management projects to distribute Rex. We are happy to support the process, so feel free to get us involved too.

### Community packages

If you maintain a repository or an overlay which includes Rex for your distribution, and you would like to get it listed here, just let us know.

## Installing from source

You can clone our [GitHub repository](https://github.com/RexOps/Rex.git) to install Rex from source. Development is done in the master branch, and we also tag each release there. Installing from source requires Dist::Zilla:

    $ git clone https://github.com/RexOps/Rex.git
    $ cd Rex
    $ cpanm Dist::Zilla
    $ dzil authordeps | cpanm
    $ dzil listdeps | cpanm
    $ dzil install

Some of the optional dependencies might not be available on all platforms, but to install them as well, use this command:

    $ dzil listdeps --suggests | cpanm
