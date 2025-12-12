class RouterHosts < Formula
  desc "Rust CLI tool for managing DNS host entries on routers via gRPC"
  homepage "https://github.com/fzymgc-house/router-hosts"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.5.0/router-hosts-aarch64-apple-darwin.tar.xz"
      sha256 "842a853ab4fd62e73ca132b3540cf24c897e6fd7c1f4bfca6ff0b2042d6ce39d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.5.0/router-hosts-x86_64-apple-darwin.tar.xz"
      sha256 "e408ead7f9cf75ec39df03c6c2fad6aa6b2c31ca201fc57627e936c8dc5ef09e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.5.0/router-hosts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b0be578b0d392544aa77d408c96828c83bceb0aeeb18393cae8ca887a2551d1e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.5.0/router-hosts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "08d8a7afda01880b0e9c6f97645358f7fe376345c20ea94bbe4f549cc2282058"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "router-hosts"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "router-hosts"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "router-hosts"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "router-hosts"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
