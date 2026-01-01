class RouterHostsOperator < Formula
  desc "Kubernetes operator for syncing Ingress hostnames to router-hosts"
  homepage "https://github.com/fzymgc-house/router-hosts"
  version "0.8.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.8/router-hosts-operator-aarch64-apple-darwin.tar.xz"
      sha256 "bdfac8a6e1ac76bc02686808e0db48d4b27bacb2e24d2c4120c3889d98ccbf84"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.8/router-hosts-operator-x86_64-apple-darwin.tar.xz"
      sha256 "9693d9cbadc2e052ad546640436309b4e5434ab29767c701550fdd98a5ec94ce"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.8/router-hosts-operator-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bdde277ff43d58f82c16bd0d38b8d9a21fe61418598c192d7d978a8fae072c42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.8/router-hosts-operator-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a366f793f382fb162e3e75432b579294d5283ace18c7af85ae464fd4b1b64a78"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "router-hosts-operator" if OS.mac? && Hardware::CPU.arm?
    bin.install "router-hosts-operator" if OS.mac? && Hardware::CPU.intel?
    bin.install "router-hosts-operator" if OS.linux? && Hardware::CPU.arm?
    bin.install "router-hosts-operator" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
