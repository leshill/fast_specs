require 'spec_helper'

describe Post do
  it "creates a post" do
    expect do
      Post.create(title: 'a title', body: 'some body text')
    end.to change(Post, :count).from(0).to(1)
  end
end
