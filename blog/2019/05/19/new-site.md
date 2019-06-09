---
title: New site engine for rexify.org
date: 2019-05-19 00:00:00
tags: news
---

After months of work on a new site backend, we reached the MVP today for
our site to be switched over to a new engine: from now on, our site will be
maintained using the static site generator
[Statocles](http://preaction.me/statocles/).

---

The switch achieves multiple goals, all of which are greatly welcomed:

* Simplified maintenance
* Faster page loads
* Hosted on GitHub Pages
* Maintenance distributed over more people


As the initial product, we've migrated all pages from the old site,
as much as possible, with the following notable differences:

* All pages were converted to Markdown where possible
* The API documentation was not migrated (instead, we defer
  [browsing our API docs](https://metacpan.org/release/Rex) to
  [MetaCPAN](https://metacpan.org/))
* The news pages were not migrated and re-adding news to our site
  is left as a post-migration step to be handled over the
  coming weeks

The contribution instructions in the GitHub repository have been
updated, so you're heartily invited to start contributing!