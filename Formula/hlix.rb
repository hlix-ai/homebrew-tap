# typed: strict
# frozen_string_literal: true

# Hlix ships a standalone executable with its runtime embedded.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  version "2.1.1"
  license :cannot_represent

  bottle do
    root_url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v2.1.1"
    sha256                               arm64_sequoia: "895526e31e625f63735dd896472ac8b9624828f33d386ba53bb15a14395baa00"
    sha256 cellar: :any_skip_relocation, sequoia:       "06b45c3b375da81a4b79fc0c83893463bbc5169a8ef48b8ecc33a49919fbd24e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7bccaa28cf86d891e129ad1a77cf125420bd8d0e7a6ebe604ce5f53f877d9dd"
  end

  on_macos do
    on_arm do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v2.1.1/hlix-2.1.1-darwin-arm64.tar.gz"
      sha256 "3d1ddf743351f252d5ca69d2a32c8cf19e9e01b8e167ee215a7360f9d26ae49d"
    end
    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v2.1.1/hlix-2.1.1-darwin-x64.tar.gz"
      sha256 "9746e50ac4ecaec6f74e60cb69853a4bc126469375013e852dd3212156628c2e"
    end
  end
  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v2.1.1/hlix-2.1.1-linux-x64.tar.gz"
      sha256 "d8daae6d5be100580fdbb9ef7520cb4fba65f2b7d3675c4321078ec6a2b8f72e"
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
