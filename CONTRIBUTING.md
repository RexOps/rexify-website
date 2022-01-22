# Contributing guide

Thank you for considering to contribute to the rexify.org website!

For optimal workflow and experience, please follow the guidelines summarized in this document.

## Getting help and support

If you need help or have questions, please use our main [support channels](https://www.rexify.org/support/index.html) for both community and commercial support, or [start a discussion](https://github.com/RexOps/rexify-website/discussions).

Please use GitHub issues for bug reports and feature requests only.

## GitHub issues and pull requests

Open GitHub [issues](https://github.com/RexOps/rexify-website/issues) to start discussing bugs or improvement ideas before proposing a specific implementation via pull requests.

Use [draft pull requests](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests#draft-pull-requests) share the details of a specific implementation proposal and ask for early feedback if needed.

## Local development

To work with the website locally, clone the repo and use the following steps:

1. Install dependencies

    cpanm --installdeps --with-develop .

1. Change something
1. Build site and start a local web server:

    statocles -l daemon

1. Open the site at the printed address (e.g. [http://0.0.0.0:3000](http://0.0.0.0:3000))

## Testing

Various Statocles plugins are checking for [valid links](https://metacpan.org/pod/Statocles::Plugin::LinkCheck) and [correct HTML](https://metacpan.org/pod/Statocles::Plugin::HTMLLint) during build time. To check locally, run:

    statocles -l build

The [build and deploy](https://github.com/RexOps/rexify-website/blob/master/.github/workflows/build_and_deploy.yml) GitHub Actions workflow runs the same tests for pull requests and branch changes.

## Deployment

The default branch is continuously deployed to GitHub pages by the [build and test](https://github.com/RexOps/rexify-website/actions/workflows/build_and_deploy.yml) GitHub Action workflow.

To manually deploy the site to GitHub Pages, you would need write access to the [`gh-pages`](https://github.com/RexOps/rexify-website/tree/gh-pages) branch. The deployment itself can be done by running:

    statocles -l deploy
