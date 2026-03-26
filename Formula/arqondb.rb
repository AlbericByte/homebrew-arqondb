class Arqondb < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/AlbericByte/arqondb"
  version "0.1.6"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.6/arqondb-0.1.6-darwin-arm64.tar.gz"
      sha256 "119490b0eed21739eaaff881e39b9135efb61f7e44459a7c44407945c3c1083f"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.6/arqondb-0.1.6-darwin-amd64.tar.gz"
      sha256 "0b395b080845b5e391c55d508e40808e1135ef02fed32c482a1ecce09a8b0ca6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.6/arqondb-0.1.6-linux-arm64.tar.gz"
      sha256 "ad320a15605bfd519969012d2fff2f09f0403896351d41e60f757d4527cddd1b"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.6/arqondb-0.1.6-linux-amd64.tar.gz"
      sha256 "c97577a04892a4043d2612a4e8fc522b81ee0ae8e468c38afd9d7340ee7a164d"
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
