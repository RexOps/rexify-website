---
title: Deprecating official Rex packages
author: Ferenc Erki
tags: news
---

As part of our efforts to simplify maintenance around RexOps projects, we have decided to stop building Rex packages on our side. We recommend relying on OS packages maintained by the various distributions in their respective upstream repositories, or to install Rex from CPAN.

---

There are multiple reasons behind this decision, and I'd like to mention some of the bigger ones below.

## Existing upstream packages in various distributions

Many operating systems are already packaging and shipping Rex in their own respective repositories, so building our own packages feels like a duplicate effort.

We believe the OS-specific packages in general are also much better in quality than what we could achieve on our own. They are maintained by their upstreams who are in much better position to follow changes of the packaging guidelines for the given distribution.

We would like to continue working together with the package maintainers, while we also encourage you to help them out for your own favorite distributions.

## Collateral packaging burden of dependencies

Packaging Rex also often involves packaging all its dependencies if they are not available in a given distribution. This multiplies the effort needed on our side to provide a proper Rex package not just by having to build all those dependencies, but also tracking each of their own new releases.

We felt this is too far outside the scope of the Rex project, and we wished we could spend the same amount of effort on Rex itself instead.

## Releases are much simpler with CPAN

Rex is a Perl project available on CPAN, and as such, it's straightforward to install it with standard Perl tools, even if you don't have superuser access on your machine.

At the same time, maintaining a multi-user package building pipeline for multiple distributions is much bigger effort than granting co-maintainer permissions on PAUSE and then using standard Perl tools for releases.

On top of that CPAN provides us with increased reliability via its mirrors and secure downloads via encrypted connections, among many other benefits.
