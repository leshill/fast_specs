# Fast Specs!

Nothing sucks the joy out of writing your Rails app like having an incredibly slow test suite. Even running one file with a single spec on my *new* MacBookPro takes almost five seconds!

	% time rspec spec/models/publish_spec.rb 
	.

	Finished in 4.48 seconds
	1 example, 0 failures

	real	0m4.592s
	user	0m3.990s
	sys	0m0.536s

Wait, maybe we can just run `ruby`?

	% time ruby -Ispec spec/models/publish_spec.rb 
	.

	Finished in 0.71331 seconds
	1 example, 0 failures

	real	0m4.468s
	user	0m3.953s
	sys	0m0.512s

Five.

Seconds.

**F I V E  SECONDS**.

*One Mississippi*, *Two Mississippi*, *Three Mississippi*, *Four Mississippi*, *Five Mississippi*.

An eternity.

Let's take a look at the admittedly ridiculous and contrived spec:

	it "publishes the item to the syndicate" do
	  syndicate = double()
	  syndicate.should_receive(:publish).with(item)
	  item.publish_to(syndicate)
	end

Maybe there is a `sleep` hiding inside `#publish_to`?

	def publish_to(syndicate)
		syndicate.publish(self)
	end

Nope.

Very little of the time spent has to do with either the code under test, or the testing code. The majority of the time is just getting the test to run.

The source of most of this is the default `spec_helper.rb` that `RSpec` generates to load up our test environment.

Asking around about this on Twitter (you should follow me [@leshill](http://twitter.com/leshill) :) yielded no examples on how you might write your specs to get some of that time back. So I wrote fast\_specs to demonstrate how to make your own specs faster.

## Writing Fast Specs

This app has two spec suites, one a normal `RSpec` suite that can be invoked as a whole with:

	% rake spec

Or invoked with individual specs with:

	% rspec spec/models/publish_spec.rb
	% ruby -Ispec spec/models/publish_spec.rb

And a **Fast Spec** suite that can be invoked as a while with:

	% rake fast

Or invoked with individual specs with:

	% rspec -Ifast_specs fast_specs/models/publish_spec.rb

In order to use the **Fast Spec** suite, we put our *fast* specs under `fast_specs` much like we do with normal `RSpec` specs. For example, the spec for the `Publish` model would be located at `fast_specs/modesl/publish_spec.rb`.

At the top of our simple spec, with no changes to the implementation or the contents of the `describe` block, we require the `fast_spec_helper`, and the `Publish` model:

	require 'fast_spec_helper'
	
	app_require 'app/models/publish'

`fast_spec_helper` adds a tiny bit of sugar by providing `app_require` which just wraps loading files from your app.

Now when we run it:

	% time rspec -Ifast_specs fast_specs/models/publish_spec.rb
	.

	real	0m0.249s
	user	0m0.183s
	sys	0m0.064s

	Finished in 0.17153 seconds
	1 example, 0 failures

**One quarter of a second.**

*Oh point two five* seconds.

Much faster.

**GO!** **FAST** **FASTER** **FASTEST** **GO!**

## Give me some support

Sometimes our code has some coupling to other parts of the system, and in those cases, we can just require the parts that we need during our spec. For example, if our `Post` depends on `Publish` our requires would look like:

	require 'fast_spec_helper'
	
	app_require 'app/models/publish'
	app_require 'app/models/post'

Not all specs are written completely with mocks (although more should be), and sometimes we need additional setup. For example, lets say that we are moving an existing *classic* TDD model spec for our `Post` that looks like this:

	it "creates a post" do
	  expect do
	    Post.create(title: 'a title', body: 'some body text')
	  end.to change(Post, :count).from(0).to(1)
	end

This spec requires accessing the database and ensuring some sort of *transactional fixture* support. We can write these support files, place them in them in `fast_specs/support` and then require them using another tiny bit of sugar with `support_require` to load our support files:

	require 'fast_spec_helper'

	support_require 'database'
	support_require 'database_cleaner'

	app_require 'app/models/publish'
	app_require 'app/models/post'

Timing this spec (which is using a transaction on the database) yields:

	% time rspec -Ifast_specs fast_specs/models/post_spec.rb 
	.

	Finished in 0.80608 seconds
	1 example, 0 failures

	real	0m0.890s
	user	0m0.701s
	sys	0m0.170s

Not bad. And most definitely faster than our previous isolated spec was :)

### Make this better!

This is only the beginning of making your specs faster. Yes, shaving 4 seconds off when running an individual spec is fantastic. If you have suggestions for more techniques or code that helps even further, make a pull request!

## Thanks

The approach outlined here is something that I just made up out of sheer frustration with the ridiculousness of waiting **5 seconds** for a simple spec.

The idea of replacing the `spec_helper.rb` was first mentioned to me by Gary Bernhardt over dinner a while back. Corey Haines has also been advocating this approach in some of his talks (and which I would love to see one of these days :)

And I know there was a blog post that suggested some serious stubbing for ActionController a while back (I cannot find it now, if you know it, please ping me.)
