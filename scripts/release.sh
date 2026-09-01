#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(git rev-parse --show-toplevel)
cd "$ROOT_DIR"

if [ "$#" -gt 1 ]; then
    echo "Usage: $0 [patch|minor|major]" >&2
    exit 2
fi

LEVEL=${1:-patch}
case "$LEVEL" in
    patch|minor|major) ;;
    *)
        echo "Usage: $0 [patch|minor|major]" >&2
        exit 2
        ;;
esac

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

git fetch origin master:refs/remotes/origin/master --tags
if [ "$(git rev-parse HEAD)" != "$(git rev-parse origin/master)" ]; then
    echo "Local master must exactly match origin/master before release." >&2
    exit 1
fi

CURRENT_TAG=$(git tag --merged HEAD --list 'v*' | sed -n '/^v[0-9]\+\.[0-9]\+\.[0-9]\+$/p' | sort -V | tail -n 1)
if ! [[ "$CURRENT_TAG" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    echo "Could not find a current vM.m.p release tag." >&2
    exit 1
fi
MAJOR=${BASH_REMATCH[1]}
MINOR=${BASH_REMATCH[2]}
PATCH=${BASH_REMATCH[3]}
CURRENT="$MAJOR.$MINOR.$PATCH"

PYTHON_CURRENT=$(sed -n 's/^version = "\([0-9][0-9.]*\)"$/\1/p' "$PYPROJECT")
CARGO_CURRENT=$(sed -n 's/^version = "\([0-9][0-9.]*\)"$/\1/p' "$CARGO_MANIFEST")
LOCK_CURRENT=$(sed -n '/^name = "mountin"$/{n;s/^version = "\([0-9][0-9.]*\)"$/\1/p;q;}' "$CARGO_LOCK")
if [ "$PYTHON_CURRENT" != "$CURRENT" ] || [ "$CARGO_CURRENT" != "$CURRENT" ] || [ "$LOCK_CURRENT" != "$CURRENT" ]; then
    echo "Python, Rust and Cargo.lock versions must match $CURRENT_TAG." >&2
    exit 1
fi

case "$LEVEL" in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    patch)
        PATCH=$((PATCH + 1))
        ;;
esac
VERSION="$MAJOR.$MINOR.$PATCH"
TAG="v$VERSION"

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
