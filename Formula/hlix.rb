# typed: strict
# frozen_string_literal: true

# Hlix ships a standalone executable with its runtime embedded.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  version "2.0.2"
  license :cannot_represent

  bottle do
    root_url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v2.0.2"
    sha256                               arm64_sequoia: "38a9e24dd885ada3aa11dcda37f110aa388c0186ce22fbe8e16d4df04086d31d"
    sha256 cellar: :any_skip_relocation, sequoia:       "98d01d6fdcbf98b4a9672a7eb4f3d1762873964fa2315b0649834f615ef3a6f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ace3f1429921e3ace170c632f8a6d79c06ef9224c807516f12d4319183394c43"
  end

  on_macos do
    on_arm do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v2.0.2/hlix-2.0.2-darwin-arm64.tar.gz"
      sha256 "f9f901cab02eff169d9924b73c261c4154866a79b0bf2402fd6cadc70b797333"
    end
    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v2.0.2/hlix-2.0.2-darwin-x64.tar.gz"
      sha256 "72a88eb9c7e049e1c7c4a8a6b3e1291c1735647354cb1669b3a731f105552e0d"
    end
  end
  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v2.0.2/hlix-2.0.2-linux-x64.tar.gz"
      sha256 "dc0fb01ce95861670879ad16c46ca458a8cc0f4ea9e263275ea9f782452ce208"
    end
  end

  def install
    bin.install "hlix"
    doc.install "THIRD_PARTY_NOTICES", "LICENSE"
  end

  # One hlix per machine: name a copy the one-line installer put here.
  def caveats
    installer = File.expand_path("~/.local/bin/hlix")
    return unless File.exist?(installer)

    <<~EOS
      Another hlix is installed at #{installer} by the one-line installer.
      Keep one: remove that copy with `#{installer} uninstall`, or this one with `brew uninstall hlix`.
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/hlix --version").strip
  end
end
