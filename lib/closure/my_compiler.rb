require 'closure-compiler'

module Closure


  class MyCompiler < Compiler

    def compile(io)
      io = io.read if io.respond_to? :read
      if io =~ /^\/\/ CLOSURE_COMPILER_SKIP_FILE/
        return io
      end
      super(io)
    end
    alias_method :compress, :compile
  end
end