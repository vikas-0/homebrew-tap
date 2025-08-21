class LocalHttps < Formula
  desc "Run any local app with HTTPS and a custom domain"
  homepage "https://github.com/vikas-0/local-https"
  url "https://github.com/vikas-0/local-https/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "<SOURCE_SHA>"
  license "MIT"

  depends_on "ruby"

  resource "thor" do
    url "https://rubygems.org/downloads/thor-1.3.1.gem"
    sha256 "<THOR_SHA>"
  end

  resource "webrick" do
    url "https://rubygems.org/downloads/webrick-1.9.1.gem"
    sha256 "<WEBRICK_SHA>"
  end

  def install
    system "gem", "build", "local-https.gemspec"

    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system "gem", "install", r.cached_download, "--no-document", "--install-dir", libexec
    end

    built = Dir["local-https-*.gem"].first
    system "gem", "install", built, "--no-document", "--install-dir", libexec

    (bin/"local-https").write_env_script libexec/"bin/local-https", GEM_HOME: libexec
  end

  test do
    assert_match "Commands:", shell_output("#{bin}/local-https --help")
  end
end
