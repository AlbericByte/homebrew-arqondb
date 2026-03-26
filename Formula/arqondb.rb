class Arqondb < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/AlbericByte/arqondb"
  version "0.1.6"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.6/arqondb-0.1.6-darwin-arm64.tar.gz"
      sha256 "417c918f8e26f89809bea3e74f9003112a5d9284dc1f84de90b558e1c7add6f9"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.6/arqondb-0.1.6-darwin-amd64.tar.gz"
      sha256 "1ad1546fa7396a513d15ada8021f52e18dd41da62863f9e930b856d1bfc2337c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.6/arqondb-0.1.6-linux-arm64.tar.gz"
      sha256 "296573766d5bcf8b199057aa532997beeb35f50e166c8800e5ad954ea9eb9e40"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.6/arqondb-0.1.6-linux-amd64.tar.gz"
      sha256 "8157679f19b59fae07c8e1684fd860b6f93750e7ee9aba804500d1040cfeaeb8"
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
