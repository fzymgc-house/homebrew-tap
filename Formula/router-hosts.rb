class RouterHosts < Formula
  desc "Rust CLI tool for managing DNS host entries on routers via gRPC"
  homepage "https://github.com/fzymgc-house/router-hosts"
  version "0.8.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.10/router-hosts-aarch64-apple-darwin.tar.xz"
      sha256 "65539d814ef7de47419883a69c8eb7d6178d9d23722bdfd463235b94e40d0193"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.10/router-hosts-x86_64-apple-darwin.tar.xz"
      sha256 "71552568f0391161000a7bfb15365d2a0e3ab3310de6dce005b1baf578a2504b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.10/router-hosts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "542af33c29342dea5239c0ff3858b94c2f810c6ab88d190eb2e280635ea01d4a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.10/router-hosts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9ccb102a83e7368af5cec6b267c3c0e043a6b0333cb0c5330d9b0ab0c040d5ce"
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
