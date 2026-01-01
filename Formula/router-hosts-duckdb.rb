class RouterHostsDuckdb < Formula
  desc "DuckDB variant of router-hosts - DNS host entry manager with DuckDB storage"
  homepage "https://github.com/fzymgc-house/router-hosts"
  version "0.8.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.9/router-hosts-duckdb-aarch64-apple-darwin.tar.xz"
      sha256 "edde0edddaf6a3d7f812fa90db19c7ea4f626699bb586b3b203b80fc26c1173e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.9/router-hosts-duckdb-x86_64-apple-darwin.tar.xz"
      sha256 "78c014bd1c68b09cf54c6037e47879692dc1d81b82b5ddd2d4e2c53fa4cdf5eb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.9/router-hosts-duckdb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "25be9d850712d45d227fb87f7d5950aecd18a6d803f313df07aae8842316d35c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.9/router-hosts-duckdb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c0cdd4762f240881e08c92ac95996db00e6d0ff219747acb94476a046ecb588"
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
