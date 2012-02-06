require 'spec_helper'

describe Instagram do
  
  it "should separately handle 504 gateway timeout" do
    Net::HTTP.any_instance.stub(:get).and_return(Net::HTTPRequestTimeOut.new("get", "504", "gateway crap"))

    Instagram.get_media("derp", 1).should eq(1)
  end
  
end