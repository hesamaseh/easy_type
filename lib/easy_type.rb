require 'easy_type/version'
require 'easy_type/parameter'
require 'easy_type/type'
require 'easy_type/parameter'
require 'easy_type/mungers'
require 'easy_type/validators'
require 'easy_type/provider'
require 'easy_type/file_includer'
require 'easy_type/script_builder'
require 'easy_type/group'
require 'easy_type/template'
require 'easy_type/helpers'

module EasyType
	def self.included(parent)
		parent.send(:include, EasyType::Helpers)
		parent.send(:include, EasyType::FileIncluder)
		parent.send(:include, EasyType::Template)
		if parent.ancestors.include?(Puppet::Type)
			parent.send(:include, EasyType::Type)
		end
		if parent.ancestors.include?(Puppet::Parameter)
			parent.send(:include, EasyType::Parameter)
		end
	end
end
