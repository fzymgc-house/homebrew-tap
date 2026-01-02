class RouterHostsDuckdb < Formula
  desc "DuckDB variant of router-hosts - DNS host entry manager with DuckDB storage"
  homepage "https://github.com/fzymgc-house/router-hosts"
  version "0.8.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.11/router-hosts-duckdb-aarch64-apple-darwin.tar.xz"
      sha256 "40da5a281d4f432c967acfe6f53962f9e3ab3235d3b1a9a7ede62c26595eaf82"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.11/router-hosts-duckdb-x86_64-apple-darwin.tar.xz"
      sha256 "c63c45eb1de53098661a57343db9c45e93ae33b07fe4f906462a4944c5645a50"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.11/router-hosts-duckdb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c433f9bd1e7adffcc97c79bc42c3e5bae4e6c0efd28e6b5a30e862304715d3c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.11/router-hosts-duckdb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a3d0d725e1d06c82046b7e39dab6c6c0d0f3ed2630c8c0b933a7f8d73c0aa046"
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
