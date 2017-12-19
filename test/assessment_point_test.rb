require 'test_helper'

describe Assembly::AssessmentPoint do
  include Assembly::TestData

  it "can fetch an assessment point" do
    id = 28
    Assembly.client.expects(:get)
      .with("/assessment_points/#{id}", {})
      .returns(example_assessment_point)
    ap = Assembly::AssessmentPoint.fetch(id)
    assert_equal Assembly::AssessmentPoint, ap.class
  end

  it "can fetch an assessment point using a different client" do
    id = 28
    client = Assembly.client(token: 'another_token')
    client.expects(:get)
      .with("/assessment_points/#{id}", {})
      .returns(example_assessment_point)
    Assembly::AssessmentPoint.fetch(id, {}, client)
  end
end