#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(git rev-parse --show-toplevel)
cd "$ROOT_DIR"

if [ "$#" -ne 1 ] || ! [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Usage: $0 M.m.p" >&2
    exit 2
fi

VERSION=$1
TAG="v$VERSION"
PYPROJECT=pyproject.toml
CARGO_MANIFEST=src/mountin/lib/mountin/Cargo.toml
CARGO_LOCK=src/mountin/lib/mountin/Cargo.lock

if [ -n "$(git status --porcelain --untracked-files=normal)" ]; then
    echo "Refusing to release a dirty checkout." >&2
    exit 1
fi

BRANCH=$(git branch --show-current)
if [ "$BRANCH" != master ]; then
    echo "Refusing to release from branch '$BRANCH'; check out master first." >&2
    exit 1
fi

CURRENT=$(sed -n 's/^version = "\([0-9][0-9.]*\)"$/\1/p' "$PYPROJECT")
if [ -z "$CURRENT" ]; then
    echo "Could not read the current Python package version." >&2
    exit 1
fi
CARGO_CURRENT=$(sed -n 's/^version = "\([0-9][0-9.]*\)"$/\1/p' "$CARGO_MANIFEST")
LOCK_CURRENT=$(sed -n '/^name = "mountin"$/{n;s/^version = "\([0-9][0-9.]*\)"$/\1/p;q;}' "$CARGO_LOCK")
if [ "$CARGO_CURRENT" != "$CURRENT" ] || [ "$LOCK_CURRENT" != "$CURRENT" ]; then
    echo "Python, Rust and Cargo.lock versions do not agree." >&2
    exit 1
fi
if [ "$VERSION" = "$CURRENT" ] || [ "$(printf '%s\n' "$CURRENT" "$VERSION" | sort -V | tail -n 1)" != "$VERSION" ]; then
    echo "Version must increase from $CURRENT to a newer M.m.p release." >&2
    exit 1
fi

git fetch origin master:refs/remotes/origin/master --tags
if [ "$(git rev-parse HEAD)" != "$(git rev-parse origin/master)" ]; then
    echo "Local master must exactly match origin/master before release." >&2
    exit 1
fi
if git rev-parse --verify --quiet "refs/tags/$TAG" >/dev/null; then
    echo "Tag already exists: $TAG" >&2
    exit 1
fi

make test

COMMITTED=0
cleanup() {
    status=$?
    trap - EXIT
    if [ "$status" -ne 0 ] && [ "$COMMITTED" -eq 0 ]; then
        git restore --staged --worktree -- "$PYPROJECT" "$CARGO_MANIFEST" "$CARGO_LOCK"
    fi
    exit "$status"
}
trap cleanup EXIT

sed -i "s/^version = \"$CURRENT\"$/version = \"$VERSION\"/" \
    "$PYPROJECT" "$CARGO_MANIFEST"
sed -i "/^name = \"mountin\"$/{n;s/^version = \"$CURRENT\"$/version = \"$VERSION\"/;}" \
    "$CARGO_LOCK"

if [ "$(sed -n 's/^version = "\([0-9][0-9.]*\)"$/\1/p' "$PYPROJECT")" != "$VERSION" ] || \
   [ "$(sed -n 's/^version = "\([0-9][0-9.]*\)"$/\1/p' "$CARGO_MANIFEST")" != "$VERSION" ]; then
    echo "Failed to update package versions." >&2
    exit 1
fi

git add "$PYPROJECT" "$CARGO_MANIFEST" "$CARGO_LOCK"
git commit -m "Release $TAG"
COMMITTED=1
git tag -a "$TAG" -m "Mountin $TAG"
git push --atomic origin master "$TAG"
