# typed: strict
# frozen_string_literal: true

# Hlix installs the published command-line client.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  url "https://registry.npmjs.org/@hlix/cli/-/cli-0.5.0.tgz"
  sha256 "f628131fce2131b4211869ef935109e76a195ad219c3f69928c7f85db7da7b26"
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
