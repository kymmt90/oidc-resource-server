# frozen_string_literal: true

Doorkeeper::OpenidConnect.configure do
  issuer 'oidc-idp-server'

  signing_key <<~KEY
    -----BEGIN PRIVATE KEY-----
    MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDobo8+umqinexo
    z33QcD5H6zHcNzlc4THm6hJVYp84v6Yh8+q7xWnYAcYZqJuI0qFlEsm++Pw5mERv
    PQnJ9lfpJp+H/2BO9jKe2Wqf03eMBmiRWe1xzHZaWJ1PQH0RoisgDOAbsurB7jF5
    X7JuAk8eQ6tOFl5YkM7Q/AoBrA5A71iJoSysqamUtiuIaNBMK+14/LQcJaTdX1QG
    2fY28u2NDVbgQtJ5HIg7sfsA2lOfuWruPvwfg2VZa9eBPbczi9Eja7wFoX0GRWVZ
    7M1KdegNhSxJPE/2eigDMhaGTyIvpPRyZwHv0s9I9XKuC4yUNyCzTBsYXskQSJQA
    uvtdXL7NAgMBAAECggEAXOcMBGOYicUboE0HGdAzZKWieUXtfK1aN9TpXQ2dXJ5l
    tf57nW/rvXYAC3N0L30ZG4Al+Vol3pN5DwlTp1D6lGtmqoItqYIIe6ulTZrFlsdc
    9nP+T1UNHVF8FxhMpUavfBEJZqjd4oPlbIEOnZ/4pb0gdIbGURoYQDntefueet8s
    0cg6oql15Owu1NsXXMyNElfNkCczKNICyPa7izPifXB9IaLCDH9AzdV8XBGxPqeo
    s8K4E8X4mHstG2PBSIlh6gSvniGSz/HQDzQamb/QI73lc78+w0Ah8UfAj21rLwib
    NMQ7BIlnPOE1IGf4VZ4aYVl8ukpClvbD5SSTgwRwVQKBgQD+y3ArsGHwSJSCciNu
    94i/sZ7BInONKJw5NG55HxRkykMAd3bms7rx5rWwmQjsE8DQ4b07q0/71r1JYh9F
    ZmHEuJ9AHwIb/9HMM91jYZvmWA99Tjz5MCmhO5TPAgMSZa2Sn3BT+Y2ilioGw+23
    mQUqf7gM3FoyaTsTOT1qTnOabwKBgQDpiAofk1kasyB6+nBM6otLk8b9HDm6HvtN
    dJNqY3zKAteGexep6MQJOwkmW5n1wguWQL0YGhM3fRMQMVi+Keb0FC+TFXjG2nKy
    9+lDK+Er2A4l4Wo/wTbSbWn0MQ/YWlVCAoEYOXvbHyHVRQrRBvoZn6hc43nYKueY
    czRrkFLIgwKBgFaotsQFP6pL5UbgrzCEvFwGe2pQ32A5WbkTHifP7E3DhTpZZ3Vb
    18+CmnUv95rjtQbWYFg1EgUjqkmVN/GQutv/txpF8Z+4SJDdawTsI+waM1p5C7/t
    I5uU+i3WD1lof7qIw9mr3QJZdH3MkcOKJfmoat7k60CODeuh4kOP3z29AoGBALhx
    UpWHuftleITIocOOB0BE0gf8r/c5GwAcz4VaWCfwwKqdM55lkdc8gkiCVoIMpTwh
    m3eauIy9wz2py849qAQkoUKI1eAwjiCdvuTnlisbtGjktRbvkk32TpWn3jzhc67z
    7WPlmtYAq6cWpalb2lI8kCv1GbnKgSod60v9K/TjAoGAOUFzU7q9P5/wcLqNoC5h
    TsiEoi9RFjdu/NAY1JMS0kyM9fAUc1y1KkE69XmybFmGr8VSqZiC4c4vMDWjFYvV
    UAz1quA5KwajI+VZsOWHzqsZfN98ier9FLvwHcmGOJws9nrBx1lijgb/gn415ee/
    tQ735yd0owi6YZpjv2kuJCE=
    -----END PRIVATE KEY-----
  KEY

  subject_types_supported [:pairwise]

  resource_owner_from_access_token do |access_token|
    User.find_by(id: access_token.resource_owner_id)
  end

  auth_time_from_resource_owner do |resource_owner|
    # Example implementation:
    # resource_owner.current_sign_in_at
  end

  reauthenticate_resource_owner do |resource_owner, return_to|
    # Example implementation:
    # store_location_for resource_owner, return_to
    # sign_out resource_owner
    # redirect_to new_user_session_url
  end

  # Depending on your configuration, a DoubleRenderError could be raised
  # if render/redirect_to is called at some point before this callback is executed.
  # To avoid the DoubleRenderError, you could add these two lines at the beginning
  #  of this callback: (Reference: https://github.com/rails/rails/issues/25106)
  #   self.response_body = nil
  #   @_response_body = nil
  select_account_for_resource_owner do |resource_owner, return_to|
    # Example implementation:
    # store_location_for resource_owner, return_to
    # redirect_to account_select_url
  end

  subject do |resource_owner, application|
    resource_owner.id
  end

  # Protocol to use when generating URIs for the discovery endpoint,
  # for example if you also use HTTPS in development
  # protocol do
  #   :https
  # end

  # Expiration time on or after which the ID Token MUST NOT be accepted for processing. (default 120 seconds).
  # expiration 600

  # Example claims:
  # claims do
  #   normal_claim :_foo_ do |resource_owner|
  #     resource_owner.foo
  #   end

  #   normal_claim :_bar_ do |resource_owner|
  #     resource_owner.bar
  #   end
  # end
end
