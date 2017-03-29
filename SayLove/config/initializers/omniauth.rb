Rails.application.config.middleware.use OmniAuth::Builder do
  provider :douban, '0e5122e5aaf4e3ec2af368b100deabc4', 'b40316c7855dbb3b'
  provider :weibo, '911483792', '0ef646dbe20f8379ae9d36f2e7a024a3'
end
