# typed: strict
# frozen_string_literal: true

# Hlix ships a standalone executable with its runtime embedded.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  version "1.0.3"
  license :cannot_represent

  bottle do
    root_url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.0.3"
    sha256                               arm64_sequoia: "5dcabd9e87044c3121fb6b58b5215a526f2f7f427b632622cdef82801a07e9c5"
    sha256 cellar: :any_skip_relocation, sequoia:       "8921a691e8905963b25193379d50905ff77318efe6cf1abf47689f97d842714f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5c96cb9a96ca13d0eca68e031053f07f6b53cb62bb0fe54a11fb02d93986ead"
  end

  on_macos do
    on_arm do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.0.3/hlix-1.0.3-darwin-arm64.tar.gz"
      sha256 "97235dfd69511a7fd86372e145c3b3e189ab066e2dc538aa9cc645fa50a9073a"
    end
    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.0.3/hlix-1.0.3-darwin-x64.tar.gz"
      sha256 "85d77abcb75232aee7cfac0cc4ff1103be283a93dfb0fdc67655243c6fda9f95"
    end
  end
  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.0.3/hlix-1.0.3-linux-x64.tar.gz"
      sha256 "5b281b34b6fd409be8726b19145408afcb3baac89f2a2f23d870b1de483234b8"
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
