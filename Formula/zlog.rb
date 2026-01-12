class Zlog < Formula
  desc "Lightweight CLI tool with browser UI for streaming NDJSON logs"
  homepage "https://github.com/w9/zlog"
  url "https://github.com/w9/zlog/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "05f680fb5f4f32845f30b50541e4dd0a20026867ae3ff1d2931fb134faa60929"
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
