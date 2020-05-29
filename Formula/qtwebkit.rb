class Qtwebkit < Formula
  desc "Qt Webkit"
  homepage "https://wiki.qt.io/Qt_WebKit"
  url "https://code.qt.io/qt/qtwebkit.git", :using => :git, :branch => '5.212',
    :revisoin => '72cfbd7664f21fcc0e62b869a6b01bf73eb5e7da'
  head "https://code.qt.io/qt/qtwebkit.git", :using => :git, :branch => '5.212'
  version "5.212-72cfbd"
  revision 3


  depends_on "yohey/legacy/qt_5.11"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  keg_only "Qt itself is keg only which implies the same for Qt modules"

  # patch for multiple math.h
  patch :DATA

  def install
    system "./Tools/Scripts/build-webkit", "--qt", "--prefix=#{prefix}", "--install"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 432ae6fce..f7bef468b 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -136,6 +136,10 @@ set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
 #------------------------------------------------------------------------------
 include(WebKitCommon)
 
+# patch for multiple math.h
+unset(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES)
+include_directories(BEFORE SYSTEM "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1")
+
 # -----------------------------------------------------------------------------
 # Enable API unit tests and create a target for the test runner
 # -----------------------------------------------------------------------------
diff --git a/Tools/Scripts/webkitdirs.pm b/Tools/Scripts/webkitdirs.pm
index 45b6649a9..81d3ed312 100755
--- a/Tools/Scripts/webkitdirs.pm
+++ b/Tools/Scripts/webkitdirs.pm
@@ -2152,8 +2152,13 @@ sub buildCMakeProjectOrExit($$$@)
 
 sub installCMakeProjectOrExit
 {
+    my $config = configuration();
+    my $buildPath = File::Spec->catdir(baseProductDir(), $config);
+    my $originalWorkingDirectory = getcwd();
+    chdir($buildPath) or die;
     my $returnCode = exitStatus(system(qw(cmake -P cmake_install.cmake)));
     exit($returnCode) if $returnCode;
+    chdir($originalWorkingDirectory);
     return 0;
 }
 
