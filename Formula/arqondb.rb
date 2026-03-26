class Arqondb < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/AlbericByte/arqondb"
  version "0.1.4"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.4/arqondb-0.1.4-darwin-arm64.tar.gz"
      sha256 "d65881f4847efb83402ccd7a88974aa2a2fcf0ecbb593b09bb925133f4a5434b"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.4/arqondb-0.1.4-darwin-amd64.tar.gz"
      sha256 "22b48b1eba5f45f6130ed3ad02c79c8a7fdb1ab64dfd9a98bc8d1c5fb3ef9294"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.4/arqondb-0.1.4-linux-arm64.tar.gz"
      sha256 "98f81003d4c83e5706a15595fc5a119ad2115cf65fcf0182419edda53920e671"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.4/arqondb-0.1.4-linux-amd64.tar.gz"
      sha256 "95874e4e063ddd7ab4448fc69bf2979e00c97996026c392f60185f49118fefcd"
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
