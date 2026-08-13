# typed: strict
# frozen_string_literal: true

# Hlix installs the published command-line client.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  url "https://registry.npmjs.org/@hlix/cli/-/cli-0.2.0.tgz"
  sha256 "9e821a4b4f492093e8f536eecc4e2b85756bf23877f2ed3291b02a39f6ca9139"
  license "Apache-2.0"

  depends_on "node"

  def install
    libexec.install Dir["*"]
    chmod 0755, libexec/"dist/index.js"
    bin.install_symlink libexec/"dist/index.js" => "hlix"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/hlix --version").strip
  end
end
