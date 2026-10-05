# typed: strict
# frozen_string_literal: true

# Hlix ships a standalone executable with its runtime embedded.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  version "0.8.0"
  license :cannot_represent

  bottle do
    root_url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v0.8.0"
    sha256                               arm64_sequoia: "5f664656eb9dacdc391657586047eabf220e7e1c02ade82fe621b2722b766640"
    sha256 cellar: :any_skip_relocation, sequoia:       "3da70526fa8952a5d8049036b2dec7ab0d91e7077aaa552ae02dc4d532d645ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e9d22b1e4a47e36d89f432c4a2a4540cc04a7367722b5bea6ec3a9f953ebc22"
  end

  on_macos do
    on_arm do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v0.8.0/hlix-0.8.0-darwin-arm64.tar.gz"
      sha256 "b7442c57786c346e33bfda171ed1ed77ea86bcf51a9dc45b6fab6965781a85e1"
    end
    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v0.8.0/hlix-0.8.0-darwin-x64.tar.gz"
      sha256 "cef94957a041aa069d4d08ad4eb1a7c7165ffaf3aabc77435642342b4cb6e7ef"
    end
  end
  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v0.8.0/hlix-0.8.0-linux-x64.tar.gz"
      sha256 "2ef14b87f972c0004fd40565673e29f5e52d5ae5bc7dfb63448a48375d126bb9"
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
