# typed: strict
# frozen_string_literal: true

# Hlix ships a standalone executable with its runtime embedded.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  version "1.3.1"
  license :cannot_represent

  bottle do
    root_url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.3.1"
    sha256                               arm64_sequoia: "0c534257aeb92ec52d20431a9ea5525d735ea327e98dd2ff34201bb412571dac"
    sha256 cellar: :any_skip_relocation, sequoia:       "e85a010922c1bcc5d8e2ea039dedc7ba16be0509c27d4ab7c8199e8a03da0ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f5fddbbd1fef72356bc7f2920c407d8fb8b1c1d971de03230fd42b1477c562c"
  end

  on_macos do
    on_arm do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.3.1/hlix-1.3.1-darwin-arm64.tar.gz"
      sha256 "1aef0b348bcf997a0a145b2dd5cd544d2f04b3b215cb201fe16b420bf05f0909"
    end
    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.3.1/hlix-1.3.1-darwin-x64.tar.gz"
      sha256 "8fabf4b04ada3e490dd1ba10cb9d5b7c809d7643af21a3f06e7cef48d5446252"
    end
  end
  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.3.1/hlix-1.3.1-linux-x64.tar.gz"
      sha256 "f4d6b746c847fb814d4ddbb73d53a6bfdeca749d53f81a6a9e398b4113d1024b"
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
