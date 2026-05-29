class Mango < Formula
  desc "Personal Finance Assistant on the Command Line"
  homepage "https://github.com/JulianLobos/mango"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/JulianLobos/mango/releases/download/v0.1.0/mango-aarch64-apple-darwin.tar.xz"
      sha256 "ea01556def106159402fe0179d609f4a445b58911a6bc8baf7551c217251aede"
    end
    if Hardware::CPU.intel?
      url "https://github.com/JulianLobos/mango/releases/download/v0.1.0/mango-x86_64-apple-darwin.tar.xz"
      sha256 "496008f1897d5062955430a1ea90897ad8e1173e9a3ec160e5fe36c201b4b00b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/JulianLobos/mango/releases/download/v0.1.0/mango-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c19ab2dc422b3a6fb01afee6b0b252810fd98c2b024b2ece323ac2c3e076d0ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/JulianLobos/mango/releases/download/v0.1.0/mango-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "82140fc364b0b299bc563f26897ff50d3a5d1ae734c34cdd0795d72bd21508d7"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-pc-windows-gnu":            {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "mango" if OS.mac? && Hardware::CPU.arm?
    bin.install "mango" if OS.mac? && Hardware::CPU.intel?
    bin.install "mango" if OS.linux? && Hardware::CPU.arm?
    bin.install "mango" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
