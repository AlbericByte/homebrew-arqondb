class Arqondb < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/AlbericByte/arqondb"
  version "0.1.3"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.3/arqondb-0.1.3-darwin-arm64.tar.gz"
      sha256 "586a20eed0938dfedb646650d08423590c724f551a856ef97158254c9ebbed25"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.3/arqondb-0.1.3-darwin-amd64.tar.gz"
      sha256 "3032c04a3fb8afcee2ca5215e5f15021dfc22b4c0ff64c14e05a5bcbd8c123bb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.3/arqondb-0.1.3-linux-arm64.tar.gz"
      sha256 "069c09844d2200bf0cfe23ac8f412cd9e2769a02fffc8aecb3c3bb0acf5bed15"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.3/arqondb-0.1.3-linux-amd64.tar.gz"
      sha256 "7eae6ab3ace5ebbfb64a6d31ecb68fcdef9c665acf36fe56f39fbf557eb29079"
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
