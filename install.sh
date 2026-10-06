#!/bin/sh
# Install hlix, the Hlix CLI, as one self-contained executable.
#
#   curl -fsSL https://hlix.ai/install.sh | bash
#   curl -fsSL https://hlix.ai/install.sh | HLIX_VERSION=0.7.1 bash
#
# Installs into ~/.local/bin (HLIX_INSTALL_DIR moves it). Never needs sudo.
# Running it again upgrades in place. Every download is checked against its
# published SHA-256 before anything is installed.
#
# One copy per machine: when Homebrew or npm already installed it, this names
# that copy and stops. `--replace` removes it with its own tool first.
set -eu

# Everything runs from main, called on the last line: a download cut short
# defines nothing runnable instead of running half an install.
main() {

# The one address this script is published at; docs link the same one. A
# staging build of the site serves it with its own host here.
INSTALL_URL="https://hlix.ai/install.sh"
RELEASES_URL="${HLIX_RELEASES_URL:-https://github.com/hlix-ai/homebrew-tap/releases/download}"
LATEST_URL="${HLIX_LATEST_URL:-https://raw.githubusercontent.com/hlix-ai/homebrew-tap/main/latest}"
NPM_HINT="Install with npm instead: npm install -g @hlix/cli"

name=hlix
folder=cli
replace=""

fail() {
  printf 'hlix install: %s\n' "$*" >&2
  exit 1
}

for arg in "$@"; do
  case "$arg" in
    --replace) replace=1 ;;
    *) fail "unknown option: $arg" ;;
  esac
done

if [ "$(id -u)" = 0 ] && [ -n "${SUDO_USER:-}" ] && [ "$SUDO_USER" != root ]; then
  fail "do not run this with sudo; hlix installs into your home directory. Run: curl -fsSL $INSTALL_URL | bash"
fi
[ -n "${HOME:-}" ] || fail "HOME is not set"

if command -v curl >/dev/null 2>&1; then
  fetch() { curl -fsSL --retry 3 -o "$2" "$1"; }
elif command -v wget >/dev/null 2>&1; then
  fetch() { wget -q -O "$2" "$1"; }
else
  fail "curl or wget is required"
fi
if command -v sha256sum >/dev/null 2>&1; then
  sha256() { sha256sum "$1" | cut -d ' ' -f 1; }
elif command -v shasum >/dev/null 2>&1; then
  sha256() { shasum -a 256 "$1" | cut -d ' ' -f 1; }
else
  fail "sha256sum or shasum is required to verify the download"
fi

case "$(uname -s)" in
  Darwin) os=darwin ;;
  Linux) os=linux ;;
  *) fail "$(uname -s) is not supported by this installer. $NPM_HINT" ;;
esac
case "$(uname -m)" in
  x86_64 | amd64) arch=x64 ;;
  arm64 | aarch64) arch=arm64 ;;
  *) fail "$(uname -m) processors are not supported by this installer. $NPM_HINT" ;;
esac
# A shell under Rosetta reports x86_64 on an Apple silicon Mac; the native build is faster.
if [ "$os" = darwin ] && [ "$arch" = x64 ] && [ "$(sysctl -n sysctl.proc_translated 2>/dev/null || true)" = 1 ]; then
  arch=arm64
fi
if [ "$os" = linux ] && { [ -f /etc/alpine-release ] || ldd --version 2>&1 | grep -qi musl; }; then
  fail "musl-based Linux (such as Alpine) is not supported by this installer. $NPM_HINT"
fi

dir="${HLIX_INSTALL_DIR:-$HOME/.local/bin}"
case "$dir" in *[\"\\]*) fail "HLIX_INSTALL_DIR cannot contain a quote or a backslash" ;; esac
target="$dir/$name"
share="${XDG_DATA_HOME:-$HOME/.local/share}/hlix/$name"
tmp=$(mktemp -d 2>/dev/null || mktemp -d -t hlix)
staged=""
trap 'rm -rf "$tmp"; if [ -n "$staged" ]; then rm -f "$staged"; fi' EXIT
trap 'exit 130' INT TERM

version="${HLIX_VERSION:-}"
if [ -z "$version" ]; then
  fetch "$LATEST_URL" "$tmp/latest" || fail "could not reach $LATEST_URL to find the latest version"
  version=$(head -n 1 "$tmp/latest")
fi
version=${version#v}
printf '%s\n' "$version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$' || fail "not a release version: $version"

# Every other copy of this program: on PATH, or installed by Homebrew or npm
# even when their folder is not on PATH. Symlinks are resolved first, so two
# ways to reach one file are one copy.
resolve() { realpath "$1" 2>/dev/null || printf '%s\n' "$1"; }
own=$(resolve "$target")
recorded=$(sed -n 's/.*"path":"\([^"]*\)".*/\1/p' "$share/install.json" 2>/dev/null || true)
seen="|"
others=""
add_copy() {
  real=$(resolve "$1")
  case "$seen" in *"|$real|"*) return 0 ;; esac
  seen="$seen$real|"
  case "$real" in
    */Cellar/hlix/*) channel=homebrew ;;
    */node_modules/@hlix/*) channel=npm ;;
    "$own") return 0 ;; # the file this install replaces in place
    *) if [ -n "$recorded" ] && [ "$real" = "$(resolve "$recorded")" ]; then channel=installer; else channel=unknown; fi ;;
  esac
  others="$others$channel $1
"
}
# The target itself may be another channel's link (an npm prefix of ~/.local).
if [ -e "$target" ]; then add_copy "$target"; fi
set -f
old_ifs=$IFS
IFS=:
for path_dir in $PATH; do
  if [ -n "$path_dir" ] && [ -f "$path_dir/$name" ] && [ -x "$path_dir/$name" ]; then add_copy "$path_dir/$name"; fi
done
IFS=$old_ifs
set +f
if [ -n "$recorded" ] && [ -x "$recorded" ]; then add_copy "$recorded"; fi
if command -v brew >/dev/null 2>&1 && brew list --formula --versions hlix >/dev/null 2>&1; then
  add_copy "$(brew --prefix)/bin/$name"
fi
if command -v npm >/dev/null 2>&1 && npm ls -g --depth=0 @hlix/cli >/dev/null 2>&1; then
  add_copy "$(npm prefix -g)/bin/$name"
fi

if [ -n "$others" ]; then
  if [ -z "$replace" ]; then
    printf '%s' "$others" | while IFS= read -r line; do
      channel=${line%% *} path=${line#* }
      case "$channel" in
        homebrew) printf 'hlix is already installed with Homebrew at %s. Keep using it: brew upgrade hlix\n' "$path" ;;
        npm) printf 'hlix is already installed with npm at %s. Keep using it: npm install -g @hlix/cli@latest\n' "$path" ;;
        installer) printf '%s is already installed by this installer at %s.\n' "$name" "$path" ;;
        *) printf '%s already exists at %s, not from Homebrew, npm or this installer. Remove it yourself to install here.\n' "$name" "$path" ;;
      esac
    done
    printf 'To replace it with the copy from this installer, run:\n  curl -fsSL %s | bash -s -- --replace\n' "$INSTALL_URL"
    fail "nothing was installed, so there is still one $name on this machine"
  fi
  # Never delete another channel's files: each copy goes through its own tool.
  printf '%s' "$others" > "$tmp/others"
  while IFS= read -r line; do
    channel=${line%% *} path=${line#* }
    case "$channel" in
      homebrew) command -v brew >/dev/null 2>&1 || fail "run brew uninstall hlix yourself, then run this again"
        brew uninstall hlix </dev/null || fail "brew uninstall hlix failed" ;;
      npm) npm uninstall -g @hlix/cli </dev/null >/dev/null || fail "npm uninstall -g @hlix/cli failed" ;;
      installer) rm -f "$path" ;;
      *) fail "$path is not from Homebrew, npm or this installer, so it is not removed. Remove it yourself, then run this again." ;;
    esac
    [ ! -e "$path" ] || fail "$path is still there after removing the $channel copy, so that tool does not own it. Remove it yourself, then run this again."
    printf 'Removed the %s copy at %s\n' "$channel" "$path"
  done < "$tmp/others"
fi

if [ -x "$target" ] && [ "$("$target" --version 2>/dev/null || true)" = "$version" ]; then
  printf '%s %s is already installed at %s\n' "$name" "$version" "$target"
  exit 0
fi

archive="$name-$version-$os-$arch.tar.gz"
url="$RELEASES_URL/cli-v$version/$archive"
printf 'Downloading %s %s for %s-%s\n' "$name" "$version" "$os" "$arch"
fetch "$url" "$tmp/$archive" || fail "could not download $url (does version $version exist?)"
fetch "$url.sha256" "$tmp/$archive.sha256" || fail "could not download $url.sha256"
expected=$(cut -d ' ' -f 1 "$tmp/$archive.sha256")
actual=$(sha256 "$tmp/$archive")
[ -n "$expected" ] && [ "$actual" = "$expected" ] ||
  fail "checksum mismatch for $archive (published $expected, downloaded $actual). Nothing was installed."
tar -xzf "$tmp/$archive" -C "$tmp"
[ -f "$tmp/$folder/$name" ] || fail "$archive does not contain $name"

mkdir -p "$dir"
# Stage beside the target, then rename: an upgrade never leaves a half-written
# file, and a running hlix keeps its old inode.
staged="$dir/.$name.$$"
cp "$tmp/$folder/$name" "$staged"
chmod 755 "$staged"
mv -f "$staged" "$target"
staged=""
mkdir -p "$share"
cp "$tmp/$folder/LICENSE" "$tmp/$folder/THIRD_PARTY_NOTICES" "$share/"
# How hlix knows this copy came from here (hlix status, hlix uninstall).
printf '{"channel":"installer","path":"%s","version":"%s"}\n' "$target" "$version" > "$share/install.json"

installed=$("$target" --version 2>/dev/null || true)
[ "$installed" = "$version" ] || fail "$target was installed but does not run on this machine (it reported: ${installed:-nothing})"
printf 'Installed %s %s to %s\n' "$name" "$version" "$target"

case ":$PATH:" in
  *":$dir:"*)
    first=$(command -v "$name" || true)
    if [ -n "$first" ] && [ "$first" != "$target" ]; then
      printf 'Note: %s comes first on your PATH, so "%s" still runs that one.\n' "$first" "$name"
    fi
    ;;
  *)
    case "$(basename "${SHELL:-sh}")" in
      zsh) profile="$HOME/.zshrc" line="export PATH=\"$dir:\$PATH\"" ;;
      bash)
        if [ "$os" = darwin ]; then profile="$HOME/.bash_profile"; else profile="$HOME/.bashrc"; fi
        line="export PATH=\"$dir:\$PATH\""
        ;;
      fish) profile="$HOME/.config/fish/config.fish" line="fish_add_path \"$dir\"" ;;
      *) profile="$HOME/.profile" line="export PATH=\"$dir:\$PATH\"" ;;
    esac
    printf '\n%s is not on your PATH. Add it, then open a new terminal:\n\n' "$dir"
    printf "  echo '%s' >> %s\n\n" "$line" "$profile"
    ;;
esac
printf 'Next: hlix auth login\n'
}

main "$@"
