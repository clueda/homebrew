require 'formula'

class Cdh4Hive < Formula
  homepage 'https://ccp.cloudera.com/display/CDH4DOC/CDH4+Release+Notes'
  url 'http://archive.cloudera.com/cdh4/cdh/4/hive-0.9.0-cdh4.1.2.tar.gz'
  version '4.1.2'
  md5 '05688edae67b27a3c60188265aff1f53'

  depends_on 'cdh4-hadoop'

    def shim_script target
      <<-EOS.undent
        #!/bin/bash
        exec "#{libexec}/bin/#{target}" "$@"
      EOS
    end

    def install
      rm_f Dir["bin/*.bat"]
      libexec.mkpath
      libexec.install %w[bin conf examples lib scripts ]
      libexec.install Dir['*.jar']
      bin.mkpath

      Dir["#{libexec}/bin/*"].each do |b|
        n = Pathname.new(b).basename
        (bin+n).write shim_script(n)
      end
    end

    def caveats; <<-EOS.undent
      Hadoop must be in your path for hive executable to work.
      After installation, set $HIVE_HOME in your profile:
        export HIVE_HOME=#{libexec}

      You may need to set JAVA_HOME:
        export JAVA_HOME="$(/usr/libexec/java_home)"
      EOS
    end

end
