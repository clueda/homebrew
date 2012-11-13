require 'formula'

class Cdh4Hadoop < Formula
  homepage 'https://ccp.cloudera.com/display/CDH4DOC/CDH4+Release+Notes'
  url 'http://archive.cloudera.com/cdh4/cdh/4/mr1-2.0.0-mr1-cdh4.1.2.tar.gz'
  version '4.1.2'
  sha1 '5721e46241de5bff1a10e9ab82a10fcb06b6b050'

  def shim_script target
      <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/bin/#{target}" "$@"
      EOS
    end

    def install
      rm_f Dir["bin/*.bat"]
      libexec.install %w[bin conf lib webapps contrib]
      libexec.install Dir['*.jar']
      bin.mkpath
      Dir["#{libexec}/bin/*"].each do |b|
        n = Pathname.new(b).basename
        (bin+n).write shim_script(n)
      end

      inreplace "#{libexec}/conf/hadoop-env.sh",
        "# export JAVA_HOME=/usr/lib/j2sdk1.6-sun",
        "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
    end

    def caveats; <<-EOS.undent
      In Hadoop's config file:
        #{libexec}/conf/hadoop-env.sh
      $JAVA_HOME has been set to be the output of:
        /usr/libexec/java_home
      EOS
    end
end
