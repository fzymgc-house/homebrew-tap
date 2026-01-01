class RouterHosts < Formula
  desc "Rust CLI tool for managing DNS host entries on routers via gRPC"
  homepage "https://github.com/fzymgc-house/router-hosts"
  version "0.8.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.6/router-hosts-aarch64-apple-darwin.tar.xz"
      sha256 "911fb16370ed80d1cbef15d566f51bb3b94c7a0a8b31dc3ecbe42161a7cb0641"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.6/router-hosts-x86_64-apple-darwin.tar.xz"
      sha256 "feab75f8f7893af2559c366febdfb627e89587f79081c069684bf731644e37a4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.6/router-hosts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cf63a555a8bb86a8b369f73cb9032556fde412e3e797301e8fc742be6c4c7da1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.6/router-hosts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "26cd983d286a7d1888272058f01a3a3649300b42eaac15e80183f67a0b452fed"
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
