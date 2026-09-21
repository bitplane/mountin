import tarfile
from pathlib import Path
from types import SimpleNamespace

from mountin.builder.downloader.download import clone_repo, export_svn, temporary_output


def test_temporary_outputs_are_unique(tmp_path):
    destination = tmp_path / "source.tar.gz"

    with temporary_output(destination) as first, temporary_output(destination) as second:
        assert first != second
        assert first.parent == destination.parent
        assert second.parent == destination.parent

    assert list(tmp_path.iterdir()) == []


def fake_git(command, **kwargs):
    if command[1] == "init":
        checkout = Path(command[2])
        checkout.mkdir()
        (checkout / ".git").mkdir()
    elif "checkout" in command:
        checkout = Path(command[2])
        (checkout / "content.txt").write_text("complete\n")
    return SimpleNamespace(returncode=0, stderr="")


def test_clone_repo_publishes_complete_archive(tmp_path, monkeypatch):
    destination = tmp_path / "output" / "source.tar.gz"
    commands = []

    def run(command, **kwargs):
        commands.append(command)
        return fake_git(command, **kwargs)

    monkeypatch.setattr("mountin.builder.downloader.download.subprocess.run", run)
    assert clone_repo("git+https://example.test/repository.git#main", destination)

    with tarfile.open(destination, "r:gz") as archive:
        assert "repository-main/content.txt" in archive.getnames()
    assert commands[2][-4:] == ["--depth", "1", "origin", "main"]


def test_full_clone_exports_tree_without_repository_history(tmp_path, monkeypatch):
    destination = tmp_path / "output" / "source.tar.gz"
    commands = []

    def run(command, **kwargs):
        commands.append(command)
        return fake_git(command, **kwargs)

    monkeypatch.setattr("mountin.builder.downloader.download.subprocess.run", run)
    assert clone_repo(
        "git-full+https://example.test/repository#deadbeef",
        destination,
        shallow=False,
    )

    with tarfile.open(destination, "r:gz") as archive:
        names = archive.getnames()
        assert "repository-deadbeef/content.txt" in names
        assert not any("/.git" in name for name in names)
    assert commands[2][-1] == "origin"


def test_svn_export_publishes_pinned_revision(tmp_path, monkeypatch):
    destination = tmp_path / "output" / "source.tar.gz"
    commands = []

    def run(command, **kwargs):
        commands.append(command)
        export = Path(command[-1])
        export.mkdir()
        (export / "content.txt").write_text("complete\n")
        return SimpleNamespace(returncode=0, stderr="")

    monkeypatch.setattr("mountin.builder.downloader.download.subprocess.run", run)
    assert export_svn("svn+https://example.test/repository#17", destination)

    with tarfile.open(destination, "r:gz") as archive:
        assert "repository-r17/content.txt" in archive.getnames()
    assert commands == [
        [
            "svn",
            "export",
            "--quiet",
            "-r",
            "17",
            "https://example.test/repository",
            commands[0][-1],
        ]
    ]
