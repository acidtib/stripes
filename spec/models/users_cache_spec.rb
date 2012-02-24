require 'spec_helper'

describe UsersCache do
  it "should not allow to inject non-numeric IDs" do
    UsersCache.create_or_update("troll", "you").should eq(false)
  end

  it "should not allow nil instagram_id" do
    UsersCache.create_or_update(nil, "you").should eq(false)
  end

  it "should not allow nil usernames" do
    UsersCache.create_or_update(123, nil).should eq(false)
  end

  it "should not allow empty everything" do
    UsersCache.create_or_update(nil, nil).should eq(false)
  end

  it "should not allow zero id" do
    UsersCache.create_or_update(0, "something").should eq(false)
  end

  it "should not allow empty string in usernames" do
    UsersCache.create_or_update(123, "").should eq(false)
  end

  it "should not allow too long usernames" do
    UsersCache.create_or_update(123, "fuckingblusssdfasdhafdsfasdfadsasfdfasd").should eq(false)
  end

  it "should not allow wrong characters in usernames" do
    UsersCache.create_or_update(123, "::$asd8 90dfa").should eq(false)
  end
end
