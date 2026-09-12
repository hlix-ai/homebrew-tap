# typed: strict
# frozen_string_literal: true

# Hlix installs the published command-line client.
class Hlix < Formula
  desc "Command-line interface for the hlix control plane"
  homepage "https://hlix.ai"
  url "https://registry.npmjs.org/@hlix/cli/-/cli-0.3.0.tgz"
  sha256 "41575714fcaa17713902b8c7a68368c971d4048c5f6c3f3d68d941dc95e20517"
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
