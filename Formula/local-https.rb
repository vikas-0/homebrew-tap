class LocalHttps < Formula
  desc "Run any local app with HTTPS and a custom domain"
  homepage "https://github.com/vikas-0/local-https"
  url "https://github.com/vikas-0/local-https/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "c7f888900d3dac4fe5e8d1b8fe7610d986731d433732e6124d1c823e02859acb"
  license "MIT"

  depends_on "ruby"

  resource "thor" do
    url "https://rubygems.org/downloads/thor-1.3.1.gem"
    sha256 "fa7e3471d4f6a27138e3d9c9b0d4daac9c3d7383927667ae83e9ab42ae7401ef"
  end

  resource "webrick" do
    url "https://rubygems.org/downloads/webrick-1.9.1.gem"
    sha256 "b42d3c94f166f3fb73d87e9b359def9b5836c426fc8beacf38f2184a21b2a989"
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
