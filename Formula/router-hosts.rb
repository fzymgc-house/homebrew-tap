class RouterHosts < Formula
  desc "Rust CLI tool for managing DNS host entries on routers via gRPC"
  homepage "https://github.com/fzymgc-house/router-hosts"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.0/router-hosts-aarch64-apple-darwin.tar.xz"
      sha256 "20854f6df21682e9b72acc2a08c21149921f98ac7dbc5fd0287861afefcaea59"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.0/router-hosts-x86_64-apple-darwin.tar.xz"
      sha256 "881ba81afbf021e50dd74e509ee3f1c28435ecf96aee3a22d25523bde1ab15af"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.0/router-hosts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c9e76184cfd766f38fbc7ac67a92d07df2d69a13911c526fd3c3bfd95d312a93"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.0/router-hosts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "884fa08bbd5a89d2427c66bbe13087fdac328d23098e8c2d50007ec7a2907ca8"
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
    bin.install "router-hosts" if OS.mac? && Hardware::CPU.arm?
    bin.install "router-hosts" if OS.mac? && Hardware::CPU.intel?
    bin.install "router-hosts" if OS.linux? && Hardware::CPU.arm?
    bin.install "router-hosts" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
