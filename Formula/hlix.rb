# typed: strict
# frozen_string_literal: true

# Hlix ships a standalone executable with its runtime embedded.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  version "0.7.2"
  license :cannot_represent

  bottle do
    root_url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v0.7.2"
    sha256                               arm64_sequoia: "365a3869ff3a67449fde85b3041ee368d7ef40752dfdfad6bd44d1e796aeb7a9"
    sha256 cellar: :any_skip_relocation, sequoia:       "ad6678e440bf07bf1d49c4663978ca074b21679ba987bfd32ceb1df25715e33f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa00b05b668e1e4fa20e2a433c5964c99fae91bf4235220508f911413dbc5feb"
  end

  on_macos do
    on_arm do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v0.7.2/hlix-0.7.2-darwin-arm64.tar.gz"
      sha256 "518072cb6328c3e5069d8d1ab8124f5d4a60ebece2fcf0efff75b2d7ecbcb6e1"
    end
    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v0.7.2/hlix-0.7.2-darwin-x64.tar.gz"
      sha256 "6dd95ce7cc1e2bec90015176fa1fc55da9cd78fc4bd11c1fe0c6db65a8fb3d6d"
    end
  end
  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v0.7.2/hlix-0.7.2-linux-x64.tar.gz"
      sha256 "9967871b44f04831e39df0e5866b2420bbebdbd88f79fc549292c8b6f50eb93a"
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
