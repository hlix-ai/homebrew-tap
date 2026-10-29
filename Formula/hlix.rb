# typed: strict
# frozen_string_literal: true

# Hlix ships a standalone executable with its runtime embedded.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  version "1.2.1"
  license :cannot_represent

  bottle do
    root_url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.2.1"
    sha256                               arm64_sequoia: "eb6874f9ad8daf382fd454c7e9151c601b88a6aab4a9979a46ad604961ed4e5f"
    sha256 cellar: :any_skip_relocation, sequoia:       "64a67359202a8f93091f4dded069e11b13943df9ac6bcfef8811cb9c8f64733e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86ea467829f78a1a0b07a0069d0e24e922225f641f0e6576706bf2e592d21ad2"
  end

  on_macos do
    on_arm do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.2.1/hlix-1.2.1-darwin-arm64.tar.gz"
      sha256 "846267729629044035c1faeee66ef9c3ccbf334660d9e938690221b5ed36c57f"
    end
    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.2.1/hlix-1.2.1-darwin-x64.tar.gz"
      sha256 "10ab7a38b90e24a9c68136e013881e38a623dd13368b7ff43f38470780b3b421"
    end
  end
  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.2.1/hlix-1.2.1-linux-x64.tar.gz"
      sha256 "d562cbe969622290e256ca46f9ff7b183ce4bff6f43730be5a58c48331d3f5e7"
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
