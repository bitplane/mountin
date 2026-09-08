---
title: Source Downloader
provides:
  - docker:builder/downloader
---

# Source Downloader

Downloads source tarballs from HTTP, Git or Subversion URLs defined in source
metadata. Reads META to get the URLs and output path, then tries each URL in
order until one succeeds.

Fetched sources have a cache identity derived only from their output path and
ordered URLs. Do not change that identity or the source-cache migration without
first measuring the resulting download set: invalidating it makes every build
host fetch the upstream archives again.
