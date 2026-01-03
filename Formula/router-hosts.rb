class RouterHosts < Formula
  desc "Rust CLI tool for managing DNS host entries on routers via gRPC"
  homepage "https://github.com/fzymgc-house/router-hosts"
  version "0.8.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.12/router-hosts-aarch64-apple-darwin.tar.xz"
      sha256 "7591099541a9835efbcaa261d07bf35a1313411d59d49163c4cf71b91a01443d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.12/router-hosts-x86_64-apple-darwin.tar.xz"
      sha256 "dfe84bffe3f0b56f5ec8c67fe42cfa316668206eb1f6b4301e562b2de862d1be"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.12/router-hosts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f94475ed02c00d48671728c118bda922ed6cf32e7638c9d66deeda04cd1fb4f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.12/router-hosts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f2ab99717b8b865874ef8395b56b597c075ce9618f03e4032e8bd0fe32e51c8c"
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
