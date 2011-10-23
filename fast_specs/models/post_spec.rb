require 'fast_spec_helper'

support_require 'database'
support_require 'database_cleaner'

app_require 'app/models/publish'
app_require 'app/models/post'

describe Post do
  it "creates a post" do
    expect do
      Post.create(title: 'a title', body: 'some body text')
    end.to change(Post, :count).from(0).to(1)
  end
end
