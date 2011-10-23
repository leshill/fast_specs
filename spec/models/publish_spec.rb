require 'spec_helper'

describe Publish do
  let(:item) do
    Class.new do |i|
      i.class_eval do
        include Publish
      end
    end.new
  end

  it "publishes the item to the syndicate" do
    syndicate = double()
    syndicate.should_receive(:publish).with(item)
    item.publish_to(syndicate)
  end
end
