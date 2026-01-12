class Zlog < Formula
  desc "Lightweight CLI tool with browser UI for streaming NDJSON logs"
  homepage "https://github.com/w9/zlog"
  url "https://github.com/w9/zlog/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "90969c3a694953eb23b7dedd79e6aac50371103edf94325da012bfb2fe68b221"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port
    begin
      pid = fork do
        exec bin/"zlog", "--port", port.to_s
      end
      sleep 2
      output = shell_output("curl -s http://127.0.0.1:#{port}/")
      assert_match "ZLOG", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
