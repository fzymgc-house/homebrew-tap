class RouterHostsDuckdb < Formula
  desc "DuckDB variant of router-hosts - DNS host entry manager with DuckDB storage"
  homepage "https://github.com/fzymgc-house/router-hosts"
  version "0.8.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.8/router-hosts-duckdb-aarch64-apple-darwin.tar.xz"
      sha256 "d6994abda4017b67b6866c8aaf5549776f0bdb63da76981f27340091eff30fee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.8/router-hosts-duckdb-x86_64-apple-darwin.tar.xz"
      sha256 "c409d25bebe822fd64665eda9c6eeea156e32d56aca0079b6dac723ee6e779b5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.8/router-hosts-duckdb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "00c2d27b1e039b6648f4303a050936a70083f485cd55b5200f5e3a64e20f4c93"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.8/router-hosts-duckdb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "88432c2c4b70f7e2838d4859c042951d69f2ec8f33ec3219725f50ed28bc9d65"
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
