# typed: strict
# frozen_string_literal: true

# Hlix ships a standalone executable with its runtime embedded.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  version "0.7.1"
  license :cannot_represent

  bottle do
    root_url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v0.7.1"
    sha256                               arm64_sequoia: "b91a934bda394f26cd7bc310a46f6f91a67a4cd212df23e0b5ad3a4d4a94559b"
    sha256 cellar: :any_skip_relocation, sequoia:       "29d1d14c85a7d37f1a7e5ffe5c629cef7b3658f907929e69afcda52eb9d7aa48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09228d387708879f33e4493d0979fe3359b3354962ca250f788f0b10c8ae43e5"
  end

  on_macos do
    on_arm do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v0.7.1/hlix-0.7.1-darwin-arm64.tar.gz"
      sha256 "cc0ec07de7cfb458defe05f81d9e0be2910504fc8be8f616e6d1273055002232"
    end
    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v0.7.1/hlix-0.7.1-darwin-x64.tar.gz"
      sha256 "ff921355c5448b28c0549dc70fc049159a6c062cd9a6032edb99cb3de3d0e654"
    end
  end
  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v0.7.1/hlix-0.7.1-linux-x64.tar.gz"
      sha256 "f6410a293855829d72c93affa8ebaf2740ab0c072d00130b1a60fff7d29b2b46"
    end
  end

  def install
    bin.install "hlix"
    doc.install "THIRD_PARTY_NOTICES", "LICENSE"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/hlix --version").strip
  end
end
