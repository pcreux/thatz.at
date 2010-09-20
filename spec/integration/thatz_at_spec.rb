require 'spec/spec_helper'

def visit(url, &block)
  context "when I visit '#{url}'" do
    let(:response) { get(URI.escape(url)) }
    subject { response.body }
    instance_eval &block
  end
end

describe "ThatzAt" do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end

  visit "/sep 20 2010 at 1pm GMT-8-DST" do
    it "should redirect to '/Sep-20-2010-13-00-GMT-8-DST'" do
      response.status.should == 302
      response.headers["Location"].should == '/Sep-20-2010-13-00-GMT-8-DST'
    end

    context "when I follow the redirect" do
      let(:body) { get(response.headers["Location"]).body }

      it "should display 'Monday Sep 20, 2010 13:00 PDT'" do
        body.should include("Monday Sep 20, 2010 13:00")
        body.should include("US/Pacific")
      end

      it "should display other timezones" do
        body.should include("Monday Sep 20, 2010 21:00")
        body.should include("GMT")
      end
    end
  end
end
