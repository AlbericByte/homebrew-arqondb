class Arqondb < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/AlbericByte/arqondb"
  version "0.1.3"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.3/arqondb-0.1.3-darwin-arm64.tar.gz"
      sha256 "acf3045396b2f4dda721edc07d4dc57f5ddc63f59ba913846555e827bdb60104"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.3/arqondb-0.1.3-darwin-amd64.tar.gz"
      sha256 "831ac58cc71bf4368f9643747155fb87b84bb4ae260a9a234ba134496ee43806"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.3/arqondb-0.1.3-linux-arm64.tar.gz"
      sha256 "40daadc76e4ecf365bd92da68f2aa89b4d09e3ef655b5034e14a0b305701524b"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.3/arqondb-0.1.3-linux-amd64.tar.gz"
      sha256 "01239cff05a8003813f970e91249654976d0f9768114b601c45c6386f50e6642"
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
