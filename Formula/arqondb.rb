class Arqondb < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/AlbericByte/arqondb"
  version "0.1.8"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.8/arqondb-0.1.8-darwin-arm64.tar.gz"
      sha256 "74aec0ab961fb81d16592af1a61d9288f590df9a8e8957505cf06f611d2319cb"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.8/arqondb-0.1.8-darwin-amd64.tar.gz"
      sha256 "80a78510a632b47df4a10d8886d0e09b171dcd3c0e8b8d24801f7652ed0bddc8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.8/arqondb-0.1.8-linux-arm64.tar.gz"
      sha256 "e442cbab9cd858746404d666b7cf8907599ca7a41cd1b6cdd81dc2ed7a575ec0"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.8/arqondb-0.1.8-linux-amd64.tar.gz"
      sha256 "6f99183726f15bb120e7441c42d016cdfad8116f49cd05a3e5cf8fb3811cb93b"
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
