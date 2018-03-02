require 'test_helper'

describe Assembly::Client do
  it "inititalizes with a default shared config" do
    client = Assembly::Client.new
    assert_equal Assembly.config, client.config
  end

  it "inititalizes with a pased config" do
    my_config = Assembly::Config.new
    client    = Assembly::Client.new(my_config)
    assert_equal my_config, client.config
  end

  it "runs a block when the token is refreshed" do
    stub_request(:post, "https://platform.assembly.education/oauth/token").
      with(:body => { "grant_type" => "refresh_token", "refresh_token" => "refresh_token" },
        :headers => { 'Accept' => 'application/vnd.assembly+json; version=1', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Basic aWQ6c2VjcmV0', 'Content-Type' => 'application/x-www-form-urlencoded', 'User-Agent' => 'Faraday v0.12.2' }).
      to_return(status: 200, body: '{"access_token": "new_access_token"}')


    access_token = 'old_access_token'
    my_config    = Assembly::Config.new(token: access_token, refresh_token: 'refresh_token', client_id: 'id', client_secret: 'secret')
    client       = Assembly::Client.new(my_config)
    client.on_token_refresh do |new_access_token|
      access_token = new_access_token[:access_token]
    end
    client.refresh_token!
    assert_equal 'new_access_token', access_token
  end

  it "refreshes the token when a token_invalid response is given" do
    stub_request(:get, "https://api.assembly.education/students").
      with(headers: { 'Accept' => 'application/vnd.assembly+json; version=1',
                      'Authorization'=>'Bearer old_access_token' }).
      to_return({ status: 401, body: '{"error": "invalid_token", "message": "token has expired"}' })

    stub_request(:get, "https://api.assembly.education/students").
      with(headers: { 'Accept' => 'application/vnd.assembly+json; version=1',
                      'Authorization'=>'Bearer new_access_token' }).
      to_return({ status: 200, body: '{}' })

    stub_request(:post, "https://platform.assembly.education/oauth/token").
      with(:body => { "grant_type" => "refresh_token", "refresh_token" => "refresh_token" },
        :headers => { 'Accept' => 'application/vnd.assembly+json; version=1', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Basic aWQ6c2VjcmV0', 'Content-Type' => 'application/x-www-form-urlencoded', 'User-Agent' => 'Faraday v0.12.2' }).
      to_return(status: 200, body: '{"access_token": "new_access_token"}')

    access_token = 'old_access_token'
    my_config    = Assembly::Config.new(token: access_token, refresh_token: 'refresh_token', client_id: 'id', client_secret: 'secret')
    client       = Assembly::Client.new(my_config)
    client.on_token_refresh do |new_access_token|
      access_token = new_access_token[:access_token]
    end
    client.get("/students")
    assert_equal 'new_access_token', access_token
  end
end
