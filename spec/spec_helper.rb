require 'coveralls'
Coveralls.wear!

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '../lib'))
require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
