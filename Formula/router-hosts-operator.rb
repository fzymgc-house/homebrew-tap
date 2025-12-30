class RouterHostsOperator < Formula
  desc "Kubernetes operator for syncing Ingress hostnames to router-hosts"
  homepage "https://github.com/fzymgc-house/router-hosts"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.7.0/router-hosts-operator-aarch64-apple-darwin.tar.xz"
      sha256 "0ac1457f37151d53d91b57aefd324f4c02c1d35427d4312dda80f004df1ee96a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.7.0/router-hosts-operator-x86_64-apple-darwin.tar.xz"
      sha256 "fb7908298a9eaace41f2f8452ff15bdb3e7177e4944e9c7a429ddda560e16597"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.7.0/router-hosts-operator-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2fe982ff61042ab738a40ff14c3547481bc283b505107f44e374aceb40d037a8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.7.0/router-hosts-operator-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ee1c2257086b98c046543ef0ff1e7889ec95b5a9f3050204d8083e3c887edd8d"
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
