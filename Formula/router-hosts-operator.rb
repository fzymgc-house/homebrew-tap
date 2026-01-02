class RouterHostsOperator < Formula
  desc "Kubernetes operator for syncing Ingress hostnames to router-hosts"
  homepage "https://github.com/fzymgc-house/router-hosts"
  version "0.8.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.11/router-hosts-operator-aarch64-apple-darwin.tar.xz"
      sha256 "9904a66711eb0bd058196e83aaf4c56400db7101013887967c355e04573f835d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.11/router-hosts-operator-x86_64-apple-darwin.tar.xz"
      sha256 "18dec28ee7e4c75bbdcfa2a8cea71d968d34d4a81231fc51ad162daa6a099723"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.11/router-hosts-operator-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9ea4ada153218fad47ccc32ee179410efb93ba63cf75cf95455a038473e9c8f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.11/router-hosts-operator-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "40237b071651b7816bffb6e73fdb9fcac0d3f0fb9bb59d632b4ff9f2e2bdc93f"
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
