class Arqondb < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/AlbericByte/arqondb"
  version "0.1.9"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.9/arqondb-0.1.9-darwin-arm64.tar.gz"
      sha256 "e637f96d0f6d9d5c7d92cd893d1f15dc4cadc7fbc10880ddd3f88eefc1e28b97"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.9/arqondb-0.1.9-darwin-amd64.tar.gz"
      sha256 "3f08f1efd75ee41cbe5c532a5646669855d193ae6bad125854f145ef9f8a0893"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.9/arqondb-0.1.9-linux-arm64.tar.gz"
      sha256 "d993d34d9ce20980452cddba198878ab994c1dec66f1c6ad249f05b3618c927c"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.9/arqondb-0.1.9-linux-amd64.tar.gz"
      sha256 "29d908770a7d765fe7e078472ab65694c99f1079ffe1b9db9f08dd0ed214956f"
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
