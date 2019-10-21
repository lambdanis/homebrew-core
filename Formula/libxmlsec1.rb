class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.2.29.tar.gz"
  sha256 "b1d1deba966019930f608d1f2b95c40ca3450f1393bcd3a3c001a8ba1d2839ab"

  bottle do
    cellar :any
    sha256 "fb781945c6de7dab1e51502d8aee4c909f37fa6e862a42a4fe58bec56e350c07" => :catalina
    sha256 "c9cc625bf2b00cdaa9ed8d59e873dfe0928931b6e62392a877d5a437757b3c5c" => :mojave
    sha256 "7ebacb8f7c89a0c8828cf721ba7385b3f0d7561549daaa0941b9a3a15186bc57" => :high_sierra
    sha256 "cec2b227a01fe451566ce854f94e187ec8f7e045a0ca570bc927bb58d3407a72" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls" # Yes, it wants both ssl/tls variations
  depends_on "libgcrypt"
  depends_on "libxml2"
  depends_on "openssl@1.1"

  # Add HOMEBREW_PREFIX/lib to dl load path
  patch :DATA

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-crypto-dl",
            "--disable-apps-crypto-dl",
            "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/xmlsec1", "--version"
    system "#{bin}/xmlsec1-config", "--version"
  end
end

__END__
diff --git a/src/dl.c b/src/dl.c
index 6e8a56a..0e7f06b 100644
--- a/src/dl.c
+++ b/src/dl.c
@@ -141,6 +141,7 @@ xmlSecCryptoDLLibraryCreate(const xmlChar* name) {
     }

 #ifdef XMLSEC_DL_LIBLTDL
+    lt_dlsetsearchpath("HOMEBREW_PREFIX/lib");
     lib->handle = lt_dlopenext((char*)lib->filename);
     if(lib->handle == NULL) {
         xmlSecError(XMLSEC_ERRORS_HERE,
