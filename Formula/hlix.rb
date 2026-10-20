# typed: strict
# frozen_string_literal: true

# Hlix ships a standalone executable with its runtime embedded.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  version "1.0.4"
  license :cannot_represent

  bottle do
    root_url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.0.4"
    sha256                               arm64_sequoia: "b7f6e89e07a33362e6db95c58f631a9ededba5ec6bd30b46fbbcaa45cc458dd7"
    sha256 cellar: :any_skip_relocation, sequoia:       "10bafb18aa56bc6a42b9ef047023e773f70e574ebd15281e4eb6afe5f0e1849e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8ced4766194e95810a5a2e3a6349a56a39289bf1cf6bb2294b6fd41ad2d5121"
  end

  on_macos do
    on_arm do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.0.4/hlix-1.0.4-darwin-arm64.tar.gz"
      sha256 "0578a044fe4c14f72fe5858afe00fcd08e36a8990355bca1e5e21c7c8ace851f"
    end
    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.0.4/hlix-1.0.4-darwin-x64.tar.gz"
      sha256 "7e4ef2096eda2bf6268e2fb34e58a9435775447311a2d0a8b21c1050a8f0bf70"
    end
  end
  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.0.4/hlix-1.0.4-linux-x64.tar.gz"
      sha256 "adad7c587cfcb5350955f51d51b080fdc3ff9d66f2729bad3faa164641e3e0c4"
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
