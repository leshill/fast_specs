module Publish
  def publish_to(syndicate)
    syndicate.publish(self)
  end
end
