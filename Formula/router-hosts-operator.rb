class RouterHostsOperator < Formula
  desc "Kubernetes operator for syncing Ingress hostnames to router-hosts"
  homepage "https://github.com/fzymgc-house/router-hosts"
  version "0.8.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.9/router-hosts-operator-aarch64-apple-darwin.tar.xz"
      sha256 "edcf029f576d51d56d831548de21bbb4cf000a81b8e8b8e99edfd6c9b1b6c991"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.9/router-hosts-operator-x86_64-apple-darwin.tar.xz"
      sha256 "6f17f88f1dfe9986bc19c8366323cb4790648185877d740533ff9f414a57e4a8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.9/router-hosts-operator-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "12e26b991c1205c587572f9645f62dd2352c2969f7a8a99982b6e981939987a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.9/router-hosts-operator-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2a34a3a415459a1dddcdd3bd72f1021a4f775a6ae476d223453fafe4787e27cd"
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
