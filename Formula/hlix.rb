# typed: strict
# frozen_string_literal: true

# Hlix ships a standalone executable with its runtime embedded.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  version "1.3.3"
  license :cannot_represent

  bottle do
    root_url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.3.3"
    sha256                               arm64_sequoia: "341cc900a4da62f8552b882dac493eb9d4c017687db0848a3794da7438474593"
    sha256 cellar: :any_skip_relocation, sequoia:       "c86eeeb1d4face63aca0c70343ea1427b6335c67157b1887644efcf082141e15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "313e08815b5889ad3d88008824488ddcd1acd8ec9120d72961100c8297a72932"
  end

  on_macos do
    on_arm do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.3.3/hlix-1.3.3-darwin-arm64.tar.gz"
      sha256 "905c73d9c3d3282ff11b42eb68f1638d2bfd33a896403f91fc7d98aa47027573"
    end
    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.3.3/hlix-1.3.3-darwin-x64.tar.gz"
      sha256 "82374c497ad088171c9d90d3245beb327bacf126b644100c031e985888a5e457"
    end
  end
  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.3.3/hlix-1.3.3-linux-x64.tar.gz"
      sha256 "323a563f6b53e70475a97ebdca21eb586f637e13877607a3fca3a14bb76635c4"
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
