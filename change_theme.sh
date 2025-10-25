#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then 
    echo "Usage: $(basename "$0") <theme-name>"
    exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

$script_dir/change_theme_on_file.sh $1
$script_dir/change_theme_with_command.sh $1
