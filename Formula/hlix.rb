# typed: strict
# frozen_string_literal: true

# Hlix installs the published command-line client.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  url "https://registry.npmjs.org/@hlix/cli/-/cli-0.4.2.tgz"
  sha256 "8e6c7a9ab6a84c039819e635eff25511c8d402c7489f4c6f033ffd23a16920b8"
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
