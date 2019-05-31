# Website content and code for rexify.org

The rexify website is powered by [Statocles](http://preaction.me/statocles/), and deployed to GitHub Pages. See below for instructions about how to work with it.

## Local development

To work with the website locally, clone the repo and use the following steps:

1. Install dependencies

        cpanm --installdeps .

1. Change something
1. Build site and start a local web server:

        statocles daemon

1. Open the site at the printed address (e.g. [http://0.0.0.0:3000](http://0.0.0.0:3000))

## Deployment

To deploy the site to GitHub Pages, you would need write access to the [`gh-pages`](https://github.com/RexOps/rexify-website/tree/gh-pages) branch. The deployment itself can be done by running:

    statocles deploy
