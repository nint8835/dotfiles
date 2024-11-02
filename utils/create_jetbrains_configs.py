import shutil

from pathlib import Path

# Parent directories to create managed config files under.
TARGET_PATHS = [Path("private_Library/private_Application Support/JetBrains")]

# JetBrains editors to create managed configs for. Must be named following the settings folder name format.
EDITORS = ["GoLand", "IntelliJIdea", "Rider"]

# Editor versions to create configs for.
VERSIONS = [
    "2024.2.3",
    "2024.2.4",
    "2024.2.7",
]

# Config files that should be managed by this repo.
MANAGED_FILES = [
    "colors.scheme.xml",
    "editor-font.xml",
    "ui.lnf.xml",
]

for target_path in TARGET_PATHS:
    shutil.rmtree(target_path, ignore_errors=True)

    target_path.mkdir(parents=True, exist_ok=True)

    for editor in EDITORS:
        for version in VERSIONS:
            version_path = target_path / f"{editor}{version}" / "options"
            version_path.mkdir(parents=True, exist_ok=True)

            for managed_file in MANAGED_FILES:
                managed_file_path = version_path / (managed_file + ".tmpl")
                managed_file_path.touch(exist_ok=True)
                managed_file_path.write_text(
                    f'{{{{- template "jetbrains/{managed_file}" . -}}}}\n'
                )
