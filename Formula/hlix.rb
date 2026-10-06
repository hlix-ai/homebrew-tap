# typed: strict
# frozen_string_literal: true

# Hlix ships a standalone executable with its runtime embedded.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  version "1.0.0"
  license :cannot_represent

  bottle do
    root_url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.0.0"
    sha256                               arm64_sequoia: "7bff0a95fe3cf81c867feb262c6251009864163148d5724d11a36f6e93642d76"
    sha256 cellar: :any_skip_relocation, sequoia:       "a7b7c8aea2d832d50f412987ad383029543ce8e02b9e0f013b325752eed5c5aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "636bbd8367200edb41c26836cb6825c2dee51342a2e283d89696db4a1b1670f3"
  end

  on_macos do
    on_arm do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.0.0/hlix-1.0.0-darwin-arm64.tar.gz"
      sha256 "de7ed65f583ccc59487a065db75a0f3afaface0a141f9fd82019d872ab11e758"
    end
    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.0.0/hlix-1.0.0-darwin-x64.tar.gz"
      sha256 "7915ccd37ebb1b780f498b1c92efa98e230e5b9e0bb151e0e4d5394d54a3a809"
    end
  end
  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.0.0/hlix-1.0.0-linux-x64.tar.gz"
      sha256 "52c271e9d06d47b97623d942f8306e3fb19328e9bbb5a05c588236966f75be97"
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
