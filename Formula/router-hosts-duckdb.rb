class RouterHostsDuckdb < Formula
  desc "DuckDB variant of router-hosts - DNS host entry manager with DuckDB storage"
  homepage "https://github.com/fzymgc-house/router-hosts"
  version "0.8.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.7/router-hosts-duckdb-aarch64-apple-darwin.tar.xz"
      sha256 "6cca8cf7745c039bf1eda9a9d38b8c4a2fc16fdcfcc71676d623feb9c5331ce7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.7/router-hosts-duckdb-x86_64-apple-darwin.tar.xz"
      sha256 "4b79f748910c92953353fe4f54cb42919c208a3bde5a3c10b5b4481fb9784019"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.7/router-hosts-duckdb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7ca8d813f15dac4da25f5f55c5d6638a69eb76a592e40d8c437955f15221448e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.7/router-hosts-duckdb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8a3137f9c458df53893a5792b491a21ffae7754615b2f7d6f9ce83c5c9db28f4"
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
