require 'spec_helper'

describe Instagram do
  
  it "should separately handle 504 gateway timeout" do
    Net::HTTP.any_instance.stub(:get).and_return(Net::HTTPRequestTimeOut.new("get", "504", "gateway crap"))
    IGNetworking::Request.init "derp"

    lambda { Instagram.handle(IGNetworking::Request.get('/foo')) }.should raise_error(GatewayTimeoutError)
  end

  it "should separately handle 502 bad gateway" do
    Net::HTTP.any_instance.stub(:get).and_return(Net::HTTPRequestTimeOut.new("get", "502", "bad gateway"))
    IGNetworking::Request.init "derp"

    lambda { Instagram.handle(IGNetworking::Request.get('/foo')) }.should raise_error(BadGatewayError)
  end

  it "should separately handle 401 unauthorized" do
    false
  end

  it "should separately handle 403 forbidden" do
    false
  end

  it "should handle any uncovered http status in range of 4xx, 5xx or xxx (unknown) range and throw generic connection error" do
    false
  end
  
end