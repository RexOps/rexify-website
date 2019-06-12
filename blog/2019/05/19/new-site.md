---
title: New site engine for rexify.org
author: Erik Huelsmann
date: 2019-05-19 00:00:00
tags: news
---

After months of work on a new site backend, we reached the MVP today for
our site to be switched over to a new engine: from now on, our site will be
maintained using the static site generator
[Statocles](http://preaction.me/statocles/).

---

The switch achieves multiple goals, all of which are greatly welcomed:

* Simplified maintenance, shared between more people
* Faster page loads
* Hosted on GitHub Pages

As the initial product, we've migrated all pages from the old site,
as much as possible, with the following notable differences:

* All pages were converted to Markdown where possible
* The API documentation was not migrated to the new site (instead
  the [API documentations](https://metacpan.org/release/Rex) simply
  links to [MetaCPAN](https://metacpan.org/))
* The news entries were not migrated and re-adding news to our site
  is left as a post-migration step to be handled over the
  coming weeks

The site-build instructions in the README in the GitHub repository
have been updated. Feel free to try them out and start contributing!
