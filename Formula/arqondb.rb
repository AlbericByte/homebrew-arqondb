class Arqondb < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/AlbericByte/arqondb"
  version "0.1.7"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.7/arqondb-0.1.7-darwin-arm64.tar.gz"
      sha256 "0ba659d734e31a1565d4af6441bf247bc6f8edd93957b71d936d61d37ddaac4a"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.7/arqondb-0.1.7-darwin-amd64.tar.gz"
      sha256 "a5241cea55529103b08ce1146daae928b7d2f3b96c6ace2b724c51b106b29ef1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.7/arqondb-0.1.7-linux-arm64.tar.gz"
      sha256 "94018bcb0c30ffdaa56868a3fe68ed01ecaf68a947279db24d653bc772251f78"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.7/arqondb-0.1.7-linux-amd64.tar.gz"
      sha256 "9383e2c7b188a86684ec359b479726a02a64a29c2b743f18b8adcd8d73fe212c"
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
