class Arqondb < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/AlbericByte/arqondb"
  version "0.1.5"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.5/arqondb-0.1.5-darwin-arm64.tar.gz"
      sha256 "0a55c98738a294134e53c146d1633918d6a6a1f9d6d429b50438e5051e35373a"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.5/arqondb-0.1.5-darwin-amd64.tar.gz"
      sha256 "7e2982edd1eee0d9a29ab154b17e09188306c317a9b7358547263e4f66c13379"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.5/arqondb-0.1.5-linux-arm64.tar.gz"
      sha256 "0a22be8d33bbadfb323102716d5b52ecadbbb49444b6431b3477c6e26d26e7d8"
    else
      url "https://github.com/AlbericByte/arqondb/releases/download/v0.1.5/arqondb-0.1.5-linux-amd64.tar.gz"
      sha256 "7cdf42eb5b52e2d428051308e7e22650d54ff86a4d821f1fe2a462bb68b3f8f5"
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
