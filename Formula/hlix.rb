# typed: strict
# frozen_string_literal: true

# Hlix ships a standalone executable with its runtime embedded.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  version "1.3.2"
  license :cannot_represent

  bottle do
    root_url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.3.2"
    sha256                               arm64_sequoia: "1743547977559a948425c44c7d664ac4f8d99b94a48bf60f66eaa90eb5c7b724"
    sha256 cellar: :any_skip_relocation, sequoia:       "ddf6f9c6db1f78e7a4e70654e8896ace5f6c4d9bc066a13eedc36d174db4d4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f31c87f86f2b7827e331550dfa46655a647d253add72a94bc2d64792c791c9fb"
  end

  on_macos do
    on_arm do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.3.2/hlix-1.3.2-darwin-arm64.tar.gz"
      sha256 "52c89056dc3a8158a92238d8efc37fa8da7e96e0576925fad36c97a1c61f137a"
    end
    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.3.2/hlix-1.3.2-darwin-x64.tar.gz"
      sha256 "7c2942adec91ff95bc5aacb7b7898b7714fa727a730939265d93902913ba5475"
    end
  end
  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.3.2/hlix-1.3.2-linux-x64.tar.gz"
      sha256 "7b1d69d2f0a856f3923773fea0ae4954255fea52ba7b8892dba6492f85aca466"
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
