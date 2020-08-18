require 'openssl'
require 'openid_connect'

class OidcClient
  PUBLIC_KEY = <<~KEY.freeze
    -----BEGIN PUBLIC KEY-----
    MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv/xRg1puYaoeCtwP8csy
    TWuAYN+/H3btAwdo4tBddvKfekd2z/m3TgN+0izC5Of8sy7wABcST69oXUtq/dPa
    oqhITCd86a5AkKcY2pE3HcaLxOIKG7zWIyufgr6IywuevjT3doo9C6Kz5qrfSkS9
    rrkabFg81cRlTC9RZCm+wmCA4NaS3Q75bY+OFGzuo2z8CZj4cPOUB/aa8f8Fx+Gd
    u/8FZ5B7U2fiQ0hKRnK9vikyF93eKyvT0/zea60oXxYL1zfsJJreQN5pqhNnhQ65
    BmkjKtZ4RBAHa7txQ+eLQRuT88XIOOjQVWQZZARjnj7qwvvrB6d+OX0CrlR+9NbS
    4wIDAQAB
    -----END PUBLIC KEY-----
  KEY
  private_constant :PUBLIC_KEY

  class << self
    def public_key
      OpenSSL::PKey::RSA.new(PUBLIC_KEY)
    end
  end

  def initialize
    @client = OpenIDConnect::Client.new(
      identifier: 'Gp3ykc00hPndLGfVnku5jAAZYi7OHpBsFLl8m2SrW6s',
      secret: 'gpXTwwQ2sHygNWcy2ZcBNyHJBXBP4ZokpQ73g442UyM',
      redirect_uri: 'http://localhost:4567/callback',
      scheme: 'http',
      host: 'localhost',
      port: '3000',
      authorization_endpoint: '/oauth/authorize',
      token_endpoint: '/oauth/token',
      userinfo_endpoint: '/oauth/userinfo',
    )
  end

  def get_access_token(code)
    @client.authorization_code = code

    @client.access_token!
  end
end
