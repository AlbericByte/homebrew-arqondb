class Arqondb < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/AlbericByte/arqondb"
  version "0.2.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.2.0/arqondb-0.2.0-darwin-arm64.tar.gz"
      sha256 "4fb05b78b3e39624ca3274546bc61232a10c23567710d6705fb5d4fdb96439e9"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.2.0/arqondb-0.2.0-darwin-amd64.tar.gz"
      sha256 "6eeeb288ae8ed1b0a69a967c2099c8d759396890ed28a1dad7ad153e8e751ade"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.2.0/arqondb-0.2.0-linux-arm64.tar.gz"
      sha256 "7018c86515b9381c4e9ef37ebd4a7f892ac644fb4943b9150c1f354f6cb2d902"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.2.0/arqondb-0.2.0-linux-amd64.tar.gz"
      sha256 "2b2e3d34f640c63341b25f2fdfcc581f00b1965afec418e7419fbe97aff73fdd"
    end
  end

  def install
    bin.install "arqondb-metadata"
    bin.install "arqondb-datanode"
    bin.install "arqondb-gateway"
    bin.install "arqondb-cli"
    bin.install "arqondb-cluster"
  end

  def post_install
    (var/"arqondb/data/node1").mkpath
    (var/"arqondb/metadata").mkpath
    (var/"log/arqondb").mkpath
  end

  service do
    run [opt_bin/"arqondb-cluster", "start"]
    keep_alive true
    working_dir var/"arqondb"
    log_path var/"log/arqondb/cluster.log"
    error_log_path var/"log/arqondb/cluster.log"
  end

  def caveats
    <<~EOS
      ArqonDB has been installed. To start the service:

        brew services start arqondb

      This will auto-start on login. To stop:

        brew services stop arqondb

      Connect:
        arqondb-cli                   # interactive REPL (gRPC)
        redis-cli -p 6379             # Redis-compatible protocol

      Management UI:
        open http://127.0.0.1:9380
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arqondb-cli --version 2>&1", 2)
  end
end
