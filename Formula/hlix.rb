# typed: strict
# frozen_string_literal: true

# Hlix ships a standalone executable with its runtime embedded.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  version "2.1.0"
  license :cannot_represent

  bottle do
    root_url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v2.1.0"
    sha256                               arm64_sequoia: "55fc154b310a9c1c4329f595009206d6a0efc881491c501e6f198aac3578a13e"
    sha256 cellar: :any_skip_relocation, sequoia:       "b1e33c07c5404231d022657a94838ff5f3a09f9413a082dd92b59820049202f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6822270bd97f90b36252790b6d3392c99b36f97a9186da30ac84f7466c61908"
  end

  on_macos do
    on_arm do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v2.1.0/hlix-2.1.0-darwin-arm64.tar.gz"
      sha256 "f4561a61aaf0ec8023c33626d4f6f81d280f7e44960f8b43098d5dba072b9aaf"
    end
    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v2.1.0/hlix-2.1.0-darwin-x64.tar.gz"
      sha256 "f4b3b1064adaebeced4bb65dfd05453490ca4f5fc8ab875d4cfe8e745b13f3a5"
    end
  end
  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v2.1.0/hlix-2.1.0-linux-x64.tar.gz"
      sha256 "5183086e4a3bbcfc89988d5fef306c90755e415004edec05733ec90ff7cae62b"
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
