$stdout.sync = true
$stderr.sync = true

require_relative 'code/app'
require_relative 'code/externals'
run App.new(Externals.new)
