from pathlib import Path
from types import SimpleNamespace

from mountin.source import (
    SourceAuthority,
    distribution_entry,
    export_source_tree,
    project_files,
)


def test_project_files_include_working_changes_and_exclude_ignored_files(tmp_path, monkeypatch):
    output = b".gitignore\0tracked\0untracked\0"
    monkeypatch.setattr(
        "mountin.source.subprocess.run",
        lambda *args, **kwargs: SimpleNamespace(stdout=output),
    )

    assert project_files(tmp_path) == [
        Path(".gitignore"),
        Path("tracked"),
        Path("untracked"),
    ]


def test_source_tree_contains_working_tree_and_preserves_file_types(tmp_path, monkeypatch):
    repository = tmp_path / "repository"
    repository.mkdir()
    (repository / "file").write_text("modified")
    (repository / "executable").write_text("#!/bin/sh\n")
    (repository / "executable").chmod(0o755)
    (repository / "link").symlink_to("file")
    monkeypatch.setattr(
        "mountin.source.project_files",
        lambda root: [Path("file"), Path("executable"), Path("link")],
    )

    destination = tmp_path / "output" / "mountin"
    identity, changed = export_source_tree(SourceAuthority("checkout", repository), destination)

    assert changed
    assert (destination / "file").read_text() == "modified"
    assert (destination / "executable").stat().st_mode & 0o111
    assert (destination / "link").is_symlink()
    assert (destination / "link").readlink() == Path("file")

    inode = destination.stat().st_ino
    repeated_identity, changed = export_source_tree(SourceAuthority("checkout", repository), destination, identity)
    assert repeated_identity == identity
    assert not changed
    assert destination.stat().st_ino == inode


def test_distribution_entries_use_canonical_package_layout(tmp_path):
    source = tmp_path / "main.py"
    source.write_text("pass\n")

    entry = distribution_entry(source, Path("mountin/main.py"))

    assert entry is not None
    assert entry.source == source
    assert entry.relative == Path("src/mountin/main.py")
    assert distribution_entry(source, Path("mountin-0.1.dist-info/RECORD")) is None
