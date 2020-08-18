# frozen_string_literal: true

Doorkeeper::OpenidConnect.configure do
  issuer 'oidc-idp-server'

  signing_key <<~KEY
    -----BEGIN PRIVATE KEY-----
    MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC//FGDWm5hqh4K
    3A/xyzJNa4Bg378fdu0DB2ji0F128p96R3bP+bdOA37SLMLk5/yzLvAAFxJPr2hd
    S2r909qiqEhMJ3zprkCQpxjakTcdxovE4gobvNYjK5+CvojLC56+NPd2ij0LorPm
    qt9KRL2uuRpsWDzVxGVML1FkKb7CYIDg1pLdDvltj44UbO6jbPwJmPhw85QH9prx
    /wXH4Z27/wVnkHtTZ+JDSEpGcr2+KTIX3d4rK9PT/N5rrShfFgvXN+wkmt5A3mmq
    E2eFDrkGaSMq1nhEEAdru3FD54tBG5Pzxcg46NBVZBlkBGOePurC++sHp345fQKu
    VH701tLjAgMBAAECggEBAL1y4IENGMWZWKIAvF8u04mgXoO552DGO2X0xuSjFsgM
    7aB9qtnaIq+CNYBzGTNHVY7/72c3XSNzBTqi9IZbq3E9PHKhuNrjz+Sub5EnIUtp
    pHz5TV5Hvsvf/TzIhjZPVit+GwBHs6uqt3oU/djM8pzbHh7yB74uWoOOYfPEWfB2
    EsOZPNNONlkgzjc5z+bKqOfYJLcwk7kQFNxclbUNOvG2yNiutfnzO0zMRE/9ENwd
    dpFEdQ5bjjTelEgVvwnyziGsHwklLX654d//jhFsTm8xWwx+aSyjWyNrixeSOwim
    TfZ5lbAZkkeC5PBraWTh/4+jV14gubzT6I9bMRgu2ckCgYEA4L2/+hiipkUtMyQz
    HA7fhKBniWmeQCQVfSJ3NvILZ2lX4lI6NVVuODbNw4jnQfchbuzK16H+TFz2Eihu
    3n91sOArAyXXgRPXCP9eIYT3AuvM37PeAzszsHCLTQFOpqWB9dnup2jfEJMLOErL
    KI0irpyFCHIn8a9wuv2aogeibNcCgYEA2rBBlpuVSu4+wU4U7Md49Wt2DE9wrWOm
    CD85xRU/iTTDahG5gqVBryWtGYM4BvAPEi5R9+PgYThgUpuEiBgrkUUQQZfcdFBO
    MltZs4Ur/8wdPgfCOR1ZCIhXZ2lhnjvvCBg0DJ8hO7snZnaJLF8pksaG0WoDhpx2
    3G4Jx4FzXNUCgYBPoizCO7R2YhCwDGWnzYVaA1RslmYiqCaNHodLityLmgIwCZ7i
    gxD5DkI+xOXcs+q+2VzOp3HqMQ5oRLd0U4mqUOQsy13fON57K7F5AxpbiJ4hriQ+
    1N1t6ZMSiCIMXpz8NmqgG0LfJptVKPtvtQLTCFcDNR/+PYIeX/pI65ecJQKBgQDB
    o3wQDad998NdivQATQgP151pfRX6kde8Sa+vkQb3SN8XlqY6xnWIzsWdZ5E+o2XU
    5WrzIrXVoAO6YbZSg4RgV1Tzn7I207zJ3hVpXiv9jhD+kgQqapAhfAhYqvkjEVKw
    Si4cVvMoXqmekqsXvROkwWEzILoKgZTFzjGelENAGQKBgQCKYhMh4YXDUEcmXv6X
    g1B8e0QRn6aAOEykxDDeED4hrFjYo/0K2OpLbUfM/FHpjD8hKPTsvUIsxcs4l5ID
    /g+34gBc3ojvOszVurgCohhEZVXNU2XzKcXkhjfHb1R26kUBA4kn1Xjb38O+QMhU
    6IeZwCEi4ojNb5FUSXpH5Sv85Q==
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

  claims do
    claim :email do |resource_owner|
      resource_owner.email
    end
  end
end
