class Arqondb < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/AlbericByte/arqondb"
  version "0.1.3"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.3/arqondb-0.1.3-darwin-arm64.tar.gz"
      sha256 "f4e0ea95e490a40c4c44db1519d970fd1d0614d32f4f8bfcc2f7029b35766373"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.3/arqondb-0.1.3-darwin-amd64.tar.gz"
      sha256 "5c3c1d3890ebfda15ee9406397b065ed9a45c75bc20dfab10da8153db8c9db40"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.3/arqondb-0.1.3-linux-arm64.tar.gz"
      sha256 "5eeb340671d7f3c20c7965a8a88f3dcd46e2bad2ae161c00c97508997d48b2c2"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.3/arqondb-0.1.3-linux-amd64.tar.gz"
      sha256 "fdc011730854c03a8caff3495018087825b3fff1c055c6d5bc9d05b9466f8a0a"
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
