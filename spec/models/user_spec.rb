require 'spec_helper'

describe User do
  it "should not allow to inject non-numeric IDs" do
    User.create_or_update("troll", "you").should eq(false)
  end

  it "should not allow nil instagram_id" do
    User.create_or_update(nil, "you").should eq(false)
  end

  it "should not allow nil usernames" do
    User.create_or_update(123, nil).should eq(false)
  end

  it "should not allow empty everything" do
    User.create_or_update(nil, nil).should eq(false)
  end

  it "should not allow zero id" do
    User.create_or_update(0, "something").should eq(false)
  end

  it "should not allow empty string in usernames" do
    User.create_or_update(123, "").should eq(false)
  end

  it "should not allow too long usernames" do
    User.create_or_update(123, "fuckingblusssdfasdhafdsfasdfadsasfdfasd").should eq(false)
  end

  it "should not allow wrong characters in usernames" do
    User.create_or_update(123, "::$asd8 90dfa").should eq(false)
  end
end
