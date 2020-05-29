class Pyside2Tools < Formula
  desc "PySide development tools (pyuic and pyrcc)"
  homepage "https://wiki.qt.io/PySide2"
  url "http://code.qt.io/pyside/pyside-setup.git", :using => :git, :branch => "5.11.2"
  version "5.11.2"
  head "http://code.qt.io/pyside/pyside-setup.git", :branch => "5.11" 


  depends_on "cmake" => :build

  option "without-python", "Build without python support"
  depends_on "python@3.8"

  depends_on "yohey/legacy/pyside2"

  def install
    Language::Python.each_python(build) do |python, version|
      mkdir "macbuild#{version}" do
        args = std_cmake_args
        args << "-DUSE_PYTHON_VERSION=#{version}"
        args << "../sources/pyside2-tools"

        system "cmake", *args
        system "make", "-j#{ENV.make_jobs}", "install"
      end
    end
  end
end
