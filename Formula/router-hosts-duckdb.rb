class RouterHostsDuckdb < Formula
  desc "DuckDB variant of router-hosts - DNS host entry manager with DuckDB storage"
  homepage "https://github.com/fzymgc-house/router-hosts"
  version "0.8.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.10/router-hosts-duckdb-aarch64-apple-darwin.tar.xz"
      sha256 "c17bb4b8dff71d82267b958787137a8bc2be712f7679e24d3c2bce16eefd3c6c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.10/router-hosts-duckdb-x86_64-apple-darwin.tar.xz"
      sha256 "3a02c6b3da2bc5bfcc44297b9f71ee3394bd576ac3660b510f2f198cfe415f9c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.10/router-hosts-duckdb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a511b72df0c35c0602fce8f0dc27f414470b5d7bdc9c1c7048435ce02b829da1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.10/router-hosts-duckdb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "90a77667bcbea0dc3f9355924222b478fd3aa30db1c3bad71075a5b1ab333d8c"
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
    bin.install "router-hosts-duckdb" if OS.mac? && Hardware::CPU.arm?
    bin.install "router-hosts-duckdb" if OS.mac? && Hardware::CPU.intel?
    bin.install "router-hosts-duckdb" if OS.linux? && Hardware::CPU.arm?
    bin.install "router-hosts-duckdb" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
