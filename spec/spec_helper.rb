require 'rspec'

$:.unshift(File.dirname(__FILE__) + '/lib')
require 'siilar'

SPEC_ROOT = File.expand_path("../", __FILE__)

require SPEC_ROOT + '/support/webmock'
require SPEC_ROOT + '/support/helpers'
