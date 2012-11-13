require 'formula'

class Cdh4Hbase < Formula
  homepage 'https://ccp.cloudera.com/display/CDH4DOC/CDH4+Release+Notes'
  url 'http://archive.cloudera.com/cdh4/cdh/4/hbase-0.92.1-cdh4.1.2.tar.gz'
  version '4.1.2'
  md5 '551ba9d02c5f19f2f5e2194f5519af34'
  
  def shim_script target
      <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/bin/#{target}" "$@"
      EOS
    end

    def install
      rm_f Dir["bin/*.bat"]
      libexec.install %w[bin conf lib hbase-webapps]
      libexec.install Dir['*.jar']
      bin.mkpath
      Dir["#{libexec}/bin/*"].each do |b|
        n = Pathname.new(b).basename
        (bin+n).write shim_script(n)
      end

      inreplace "#{libexec}/conf/hbase-env.sh",
        "# export JAVA_HOME=/usr/java/jdk1.6.0/",
        "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
    end

    def caveats; <<-EOS.undent
      In Hadoop's config file:
        #{libexec}/conf/hbase-env.sh
      $JAVA_HOME has been set to be the output of:
        /usr/libexec/java_home
      EOS
    end
  
end
