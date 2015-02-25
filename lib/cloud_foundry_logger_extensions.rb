class Logger
  alias :rails_initialize :initialize
  def initialize(*args)
    @prefix = "[git-commit-integration] "
    unless args[0].is_a?(IO)
      @prefix += "[#{args[0].to_s.split('/').last}] "
    end

    STDOUT.sync
    args[0] = STDOUT
    rails_initialize(*args)
  end

  alias :old_add :add
  def add(severity, progname = nil, message = nil, &block)
    # There's confusion over what the signature of this method is in the various places it is monkey-patched in
    # Rails and elsewhere.  Sometimes progname and message are switched.  So, we prepend the prefix to both.
    # Worst case, we might get it twice, but it doesn't seem to happen in practice.
    if progname
      progname = "#{@prefix}#{progname}"
    else
      message = "#{@prefix}#{message}"
    end
    old_add(severity, progname, message, &block)
  end
end
