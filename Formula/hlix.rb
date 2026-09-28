# typed: strict
# frozen_string_literal: true

# Hlix ships the installed CLI and its runtime dependencies.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  version "0.7.0"
  license :cannot_represent

  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v0.7.0/hlix-0.7.0-darwin-arm64.tar.gz"
      sha256 "304a4dcc52abde3b3b889cb2a00ef42097ef2de4abaef0aa17d0765c47f44698"
    end
    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v0.7.0/hlix-0.7.0-darwin-x64.tar.gz"
      sha256 "d6c1378a7a5a0f8ca0b7dba415e0432ebc3ff2651224e6de4c805515dd786892"
    end
  end
  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/hlix-ai/homebrew-tap/releases/download/cli-v0.7.0/hlix-0.7.0-linux-x64.tar.gz"
      sha256 "ec5c4bc14230d45559842618779f3ba38c2940583728466f2ed4b43697817069"
    end
  end

  def install
    libexec.install Dir["*"]
    node = Formula["node"]
    (bin/"hlix").write_env_script libexec/"dist/index.js", PATH: "#{node.opt_bin}:$PATH"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/hlix --version").strip
  end
end
