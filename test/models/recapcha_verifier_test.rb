require 'test_helper'

class RecaptchaVerifierTest < ActiveSupport::TestCase

  def setup
    resp = {}
    @rec = RecaptchaVerifier.new(resp, nil)
  end

  test 'url should contain secret' do
    assert @rec.secret
  end

end
