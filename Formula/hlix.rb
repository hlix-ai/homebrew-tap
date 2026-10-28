# typed: strict
# frozen_string_literal: true

# Hlix ships a standalone executable with its runtime embedded.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  version "1.1.0"
  license :cannot_represent

  bottle do
    root_url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.1.0"
    sha256                               arm64_sequoia: "b8bd18b09d7fcf42de188931c4fdcd7db4c902cd0dda98a0fd27dda557598e13"
    sha256 cellar: :any_skip_relocation, sequoia:       "96a7eafa37322af70c6c61a60a2afdd57797750dee33afbdc9547443364d2d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99bebe0ae44defa93846d97f954907a71dcc71d6dff92627628df8607eabb33d"
  end

  on_macos do
    on_arm do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.1.0/hlix-1.1.0-darwin-arm64.tar.gz"
      sha256 "3dae3e7fb06cee299080c91ada29855f1f7fdd1d174c9b9ef256e268dd4063cb"
    end
    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.1.0/hlix-1.1.0-darwin-x64.tar.gz"
      sha256 "33991f0c71a21347285a4d5a2eed2f558e43dec0ce63cdbe62589ebda31d6874"
    end
  end
  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.1.0/hlix-1.1.0-linux-x64.tar.gz"
      sha256 "2f49e501465bd984b92f3252c61e121866465eecc1e85bd17a1aab7b3f4bb583"
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
