require 'puppet/file_serving'
require 'puppet/file_serving/content'

module EasyType
  #
  # Contains a template helper method. 
  #
  module Template

    # @private
    def self.included(parent)
      parent.extend(Template)
    end
    ##
    #
    # This allows you to use an erb file. Just like in the normal Puppet classes. The file is searched
    # in the template directory on the same level as the ruby library path. For most puppet classes
    # this is eqal to the normal template path of a module
    # 
    # @example
    #  template 'puppet:///modules/my_module_name/create_tablespace.sql.erb', binding
    #
    # @param [String] name this is the name of the template to be used. 
    # @param [Binding] context this is the binding to be used in the template
    #
    # @raise [ArgumentError] when the file doesn't exist
    # @return [String] interpreted ERB template
    #
    def template(name, context)
      ERB.new(load_file(name).content).result(context)
    end

  private
    def load_file(name)
      # require 'ruby-debug'
      # debugger
      terminus  = runs_standalone? ? :file_server : :rest
      with_terminus(terminus) do
        template_file = Puppet::FileServing::Content.indirection.find(name)
        raise ArgumentError, "Could not find template '#{name}'" unless template_file
        template_file
      end
    end

    def runs_standalone?
      #
      # There does not seem to be a deterministic way to decide if we are on a standalone system
      # or running in conjunction with a puppet master. So we deduct that when the reporturl contains
      # the term localhost, we are running standalone
      # TODO: Find a deterministic way to decide
      #
      Puppet[:catalog_terminus] == :compiler && Puppet[:reporturl].to_s.include?('localhost')
    end

    def with_terminus(terminus)
      old_terminus = Puppet[:default_file_terminus]
      Puppet[:default_file_terminus] = terminus
      value = yield
      Puppet[:default_file_terminus] = old_terminus
      value
    end
  end

end
