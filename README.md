# Website content and code for rexify.org [![Build Status](https://travis-ci.com/RexOps/rexify-website.svg?branch=master)](https://travis-ci.com/RexOps/rexify-website)

The rexify website is powered by [Statocles](http://preaction.me/statocles/), and deployed to GitHub Pages. See below for instructions about how to work with it.

## Local development

To work with the website locally, clone the repo and use the following steps:

1. Install dependencies

        cpanm --installdeps --with-develop .

1. Change something
1. Build site and start a local web server:

        statocles -l daemon

1. Open the site at the printed address (e.g. [http://0.0.0.0:3000](http://0.0.0.0:3000))

## Deployment

The master branch is continuously deployed to GitHub pages by Travis CI.

To manually deploy the site to GitHub Pages, you would need write access to the [`gh-pages`](https://github.com/RexOps/rexify-website/tree/gh-pages) branch. The deployment itself can be done by running:

    statocles deploy --clean
