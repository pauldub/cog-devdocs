require 'spec_helper'

describe 'the devdocs:doc command' do
  let(:command_name) { 'doc' }
  it do
    run_command(args: ['rails', 'ActionController::Base'])
    puts command.response.content
  end

end
