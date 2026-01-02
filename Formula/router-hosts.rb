class RouterHosts < Formula
  desc "Rust CLI tool for managing DNS host entries on routers via gRPC"
  homepage "https://github.com/fzymgc-house/router-hosts"
  version "0.8.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.11/router-hosts-aarch64-apple-darwin.tar.xz"
      sha256 "556e735778af1e40d7c15f9db7b4e9b628c719edffe5d2f999e399beb3279ad5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.11/router-hosts-x86_64-apple-darwin.tar.xz"
      sha256 "0596c798a869f6345ad45ff3d7cae315ff5e5e9b06cd09b1a3407a9c2976d379"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.11/router-hosts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e58fc82943cf94b0345d4a63f10d815dcfd1edf55b4066b2dfe237015e9fd865"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fzymgc-house/router-hosts/releases/download/v0.8.11/router-hosts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "091b3af6d5e2471993b4a5b8c108bb3843038924b0fa66ed271401b6c5b2227f"
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
