# typed: strict
# frozen_string_literal: true

# Hlix ships a standalone executable with its runtime embedded.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  version "1.0.2"
  license :cannot_represent

  bottle do
    root_url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.0.2"
    sha256                               arm64_sequoia: "b09cafdd793e21cbd522e1ed6185e7f3aba42ca8592a4798fcb36fc8238d1536"
    sha256 cellar: :any_skip_relocation, sequoia:       "d6d1ee1569eb400ad3f28c2c3f2a4bb066b7b02dfd708271f6d85f19a707db20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f945febc026fa6275aa62291ed3e2ed27398862b719f70555573bf7088b1325"
  end

  on_macos do
    on_arm do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.0.2/hlix-1.0.2-darwin-arm64.tar.gz"
      sha256 "f62a7e2950bff1a3dcc0419d8d4327c72f7ef6f36433d8f4c01d784fa3097219"
    end
    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.0.2/hlix-1.0.2-darwin-x64.tar.gz"
      sha256 "462a2a82287221716a22165cdcf732119a8f64e4c1361e8e848689571e5250d8"
    end
  end
  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.0.2/hlix-1.0.2-linux-x64.tar.gz"
      sha256 "2dbbe5c9efa23aebe01005cd863fa3628c14f901b96048538973a582870086dd"
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
