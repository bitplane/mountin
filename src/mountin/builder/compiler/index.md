---
title: Compilers
---

# Compilers

Unversioned `builder/compiler/<os>` images are internal, source-independent
Linux bootstraps. Versioned descendants are complete operating-system
toolboxes: they contain the matching compiler, sysroot, usable source tree and
any prepared build state needed by downstream guest assembly.

Versioned toolboxes have no entrypoint, start in `/work`, and work without a
Mountin build directory or provider cache. Conventional compiler variables are
exported where the target supports them. Their common filesystem views are:

- `/opt/mountin/source` for the primary operating-system source tree;
- `/opt/mountin/sources` for additional extracted component sources;
- `/opt/mountin/build` for prepared, resumable target build state;
- `/opt/mountin/sysroot` for the target SDK or sysroot.

Only applicable paths are present. The underlying files may remain at
upstream-required locations, with the common paths acting as stable views.
