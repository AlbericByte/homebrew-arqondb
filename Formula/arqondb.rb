class Arqondb < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/AlbericByte/arqondb"
  version "0.2.1"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.2.1/arqondb-0.2.1-darwin-arm64.tar.gz"
      sha256 "9ef7855334b720e691a102790a080041e822a05d9605aad6c5c31624a62da195"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.2.1/arqondb-0.2.1-darwin-amd64.tar.gz"
      sha256 "22e6b4ccc053092315b8e77fd1dc87c7840b733a04cb70c98f233bc3669e8c85"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.2.1/arqondb-0.2.1-linux-arm64.tar.gz"
      sha256 "ea20c62f5c7df36e0e4847c67657ae92d841e0fcb50fd6a10c39d0d43be9b43c"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.2.1/arqondb-0.2.1-linux-amd64.tar.gz"
      sha256 "d0609bb22673899a236f756e577d4d5f2feb3cd17e8a38d30065e8386206fd19"
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
