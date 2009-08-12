require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.terminate_instances' do

  before(:all) do
    @ec2 = Fog::AWS::EC2.gen
    @instance_id = @ec2.run_instances('ami-5ee70037', 1, 1).body['instancesSet'].first['instanceId']
  end

  it "should return proper attributes" do
    actual = @ec2.terminate_instances([@instance_id])
    actual.body['requestId'].should be_a(String)
    actual.body['instancesSet'].should be_an(Array)
    instance = actual.body['instancesSet'].select {|instance| instance['instanceId'] == @instance_id}.first
    instance['previousState'].should be_a(Hash)
    previous_state = instance['previousState']
    previous_state['code'].should be_a(Integer)
    previous_state['name'].should be_a(String)
    instance['shutdownState'].should be_a(Hash)
    shutdown_state = instance['shutdownState']
    shutdown_state['code'].should be_a(Integer)
    shutdown_state['name'].should be_a(String)
  end

end
