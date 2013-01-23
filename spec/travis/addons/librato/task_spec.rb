require 'spec_helper'

describe Travis::Addons::Librato::Task do
  alias :stub_webrequest :stub_request
  include Travis::Testing::Stubs

  let(:http)    { Faraday::Adapter::Test::Stubs.new }
  let(:client)  { Faraday.new { |f| f.request :url_encoded; f.adapter :test, http } }
  let(:targets) { %w{travis-annotation other-annotation} }
  let(:subject) { Travis::Addons::Librato::Task }
  let(:payload) { Travis::Api.data(build, for: 'event', version: 'v0').deep_symbolize_keys }
  let(:handler) { subject.new(payload, targets: targets) }

  before :each do
    payload[:build][:config].merge!(notifications: {librato: {email: 'mathias@travis-ci.org', token: '12345'}})
    handler.stubs(:http).returns(client)
  end

  it 'posts to all annotations specified' do
    http.post("v1/annotations/travis-annotation") {|env|}
    http.post("v1/annotations/other-annotation") {|env|}
    handler.run
  end

  it "includes a title in the payload" do
    handler.params[:targets] = "travis-annotation"
    http.post("v1/annotations/travis-annotation") do |request|
      body = MultiJson.decode(request[:body])
      body['title'].should =~ /Travis CI: Build #[0-9] passed/
    end
    handler.run
  end

  it "include links in the payload" do
    handler.params[:targets] = "travis-annotation"
    http.post("v1/annotations/travis-annotation") do |request|
      body = MultiJson.decode(request[:body])
      body["links"].should have(2).items
      body["links"].first["link"].should == "https://travis-ci.org/svenfuchs/minimal/builds/1"
      body["links"].last["link"].should =~ %r{https://github.com/svenfuchs/minimal/compare/master...develop}
    end
    handler.run
  end

  it "doesn't barf when one request raises an error" do
    http.post("v1/annotations/travis-annotation") do |env|
      [403, {}, "{}"]
    end
    http.post("v1/annotations/other-annotation") {|env|}
    handler.run
  end

  it "authenticates requests with email and token"do
    handler.params[:targets] = "travis-annotation"
    http.post("v1/annotations/travis-annotation") do |env|
      env[:request_headers]["Authorization"].should == "Basic bWF0aGlhc0B0cmF2aXMtY2kub3JnOjEyMzQ1"
    end
    handler.run
  end
end
