# typed: strict
# frozen_string_literal: true

# Hlix ships a standalone executable with its runtime embedded.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  version "1.2.0"
  license :cannot_represent

  bottle do
    root_url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.2.0"
    sha256                               arm64_sequoia: "683cd1d034a39284fcd8b3b476d0a292fc2f72bb15d6ddf18e0fc4e3921a2821"
    sha256 cellar: :any_skip_relocation, sequoia:       "61549bc6d926ee9c510e98662e868028be5e19721106586ab2c23794876c18bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9144fb86409f23ecfbe9ab831e5807dd595df11e3d56741d687f67347fd98eb"
  end

  on_macos do
    on_arm do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.2.0/hlix-1.2.0-darwin-arm64.tar.gz"
      sha256 "efa276c66c4ae2702c90fd201a3027a0fb5c76fe36418cb2c191f046849a28db"
    end
    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.2.0/hlix-1.2.0-darwin-x64.tar.gz"
      sha256 "8fbf28617fff9f2f34ffd217244bf0d8931e2e7b494acd5fe8308f270e2ea8a3"
    end
  end
  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v1.2.0/hlix-1.2.0-linux-x64.tar.gz"
      sha256 "1a444e4f2516242585900623983e869311dc851b64c50b28fb65d781de73e078"
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
