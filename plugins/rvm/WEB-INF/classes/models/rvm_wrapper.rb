require 'stringio'

class RvmWrapper < Jenkins::Tasks::BuildWrapper
  display_name "Run the build in a RVM-managed environment"

  attr_accessor :impl

  def initialize(attrs)
    @impl = fix_empty attrs['impl']
  end

  def setup(build, launcher, listener)
    arg = @impl

    listener << "Capturing environment variables produced by 'rvm use #{arg}'\n"
    
    before = StringIO.new()
    if launcher.execute("bash","-c","export", {:out=>before})!=0 then
      listener << "Failed to fork bash\n"
      listener << before.string
      build.abort
    end

    if launcher.execute("bash","-c","test ! -f ~/.rvm/scripts/rvm")==0 then
      listener << "Installing RVM\n"
      installer = build.workspace+"rvm-installer"
      installer.native.copyFrom(java.net.URL.new("https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer"))
      installer.chmod(0755)
      launcher.execute(installer.realpath, {:out=>listener})
    end

    after = StringIO.new()
    if launcher.execute("bash","-c","source ~/.rvm/scripts/rvm && rvm_install_on_use_flag=1 && rvm use --create #{arg} && export > rvm.env", {:out=>listener,:chdir=>build.workspace})!=0 then
      build.abort "Failed to setup RVM environment"
    end

    bh = to_hash(before.string,listener)
    ah = to_hash((build.workspace+"rvm.env").read,listener)
    ah.each do |k,v|
      bv = bh[k]

      next if k=="HUDSON_COOKIE" || k=="JENKINS_COOKIE" # cookie Jenkins uses to track process tree. ignore.
      next if bv==v  # no change in value

      if k=="PATH" then
        # look for PATH components that include ".rvm" and pick those up
        path = v.split(File::PATH_SEPARATOR).find_all{|p| p =~ /[\\\/]\.rvm[\\\/]/ }.join(File::PATH_SEPARATOR)
        build.env["PATH+RVM"] = path
        #listener.debug "Adding PATH+RVM=#{path}"
      else
        #listener.debug "Adding #{k}=#{v}"
        build.env[k] = v
      end
    end
  end

  private

  def fix_empty(s)
    s=="" ? nil : s
  end

  def to_hash(export,listener)
    r = {}
    export.split("\n").each do |l|
      if l.start_with? "declare -x " then
        l = l[11..-1]  # trim off "declare -x "
        k,v = l.split("=",2)
        if v then
          r[k] = (v[0]==?" || v[0]==?') ? v[1..-2] : v # trim off the quote surrounding it
        end
      end
    end
    r
  end
end