class RouterHostsOperator < Formula
  desc "Kubernetes operator for syncing Ingress hostnames to router-hosts"
  homepage "https://github.com/fzymgc-house/router-hosts"
  version "0.8.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.7/router-hosts-operator-aarch64-apple-darwin.tar.xz"
      sha256 "3710f5cadfbf47226d85e8866c341f60c58f444f8b4950a91bfebce000c4beeb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.7/router-hosts-operator-x86_64-apple-darwin.tar.xz"
      sha256 "c82faa0367fcc61fb7f1ab35b74fb2f373fa9f24abed3fae9878b4443dfe9973"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.7/router-hosts-operator-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "deea1463887f5f75449b28687d710d70ddab8e8482e29abfac4bd5516989bb1d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.7/router-hosts-operator-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "95a0f875663a8a8ef75d7dd4429591c0881484befb363b8a67b9b2b482677be1"
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
