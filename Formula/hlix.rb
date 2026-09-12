# typed: strict
# frozen_string_literal: true

# Hlix installs the published command-line client.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  url "https://registry.npmjs.org/@hlix/cli/-/cli-0.4.1.tgz"
  sha256 "8083e13e407519e36799ea2ba79878c5b201fde233ea25695753a54f64d34768"
  license :cannot_represent

  depends_on "node"

  def install
    # The CLI has runtime dependencies (the Hlix Code harness), so it is
    # installed the way Homebrew installs every npm package: npm install
    # into libexec, which resolves them, then the bin it declares is linked.
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/hlix --version").strip
  end
end
