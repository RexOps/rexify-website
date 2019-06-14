---
title: Post-migration updates & clean-up
tags: news
author: Erik Huelsmann
---

Over the course of the past weeks many clean-ups have been
done, reaping the benefits provided by our new
[Statocles](https://preaction.me/statocles)-based site:

---

* Added back the ability maintain News on the site
* Remove "Fork me on GitHub" banner for improved mobile usability
* Cleaned unused parts from GitHub repository ('master' branch)
* Removed all JavaScript components we could:
  * Moved the menu from JavaScript to CSS+HTML
  * Moved the 'Get Rex' page to CSS+HTML (pre-migration)
  * browserJS not used in recent versions of the site
  * jQuery used to be used by now-removed administrative part of the old site
  * Removed all bootstrap plugins; they were unused
