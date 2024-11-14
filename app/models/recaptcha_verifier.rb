# app/models/recaptcha_verifier.rb
class RecaptchaVerifier
  def initialize(response, ip)
    @response = response
    @ip = ip
  end

  def self.verify(response, ip = nil)    
    new(response, ip).verify
  end

  def verify
    return true
    return true if Rails.env.test?
    recaptcha_response = HTTParty.get(recaptcha_url(@response, secret, @ip))   
    response_success?(recaptcha_response)
  end

  def recaptcha_url(response, secret, ip)
    "https://www.google.com/recaptcha/api/siteverify?secret=#{secret}&response=#{response}&remoteip=#{ip}"
  end

  def secret
    # load your secret here or hardcode it
    ENV["RECAPTCHA_PRIVATE_KEY"]
  end

  def response_success?(response)
    response.fetch('success')
  end
end
