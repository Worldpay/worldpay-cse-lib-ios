Pod::Spec.new do |s|
  s.name              = 'WorldpayCSE'
  s.version           = '1.0.2'
  s.summary           = 'Worldpay Client Side Encryption library'
  s.license           = { :type => 'Worldpay', :file => 'LICENSE' }
  s.author            = 'Worldpay'
  s.homepage          = 'https://github.com/Worldpay/worldpay-cse-lib-ios'
  s.description       = 'Worldpay Client Side encryption library for easy integration with your existing and new applications.'
  s.documentation_url = 'http://support.worldpay.com/support/kb/gg/client-side-encryption/Content/A%20-%20Home/Home.htm'

  s.default_subspec   = "Core"

  s.source            = { :git => 'https://github.com/Worldpay/worldpay-cse-lib-ios.git', :tag => s.version  }

  s.platform          = :ios, '7.0'

  s.preserve_paths = 'WorldPayCSE/Thirdparty/OpenSSL/openssl.framework'

  s.subspec "Core" do |core|
    core.dependency 'WorldpayCSE/OpenSSL'
    core.source_files        = 'WorldPayCSE/WorldPayCSE/**/*.{h,m}'
    core.public_header_files = 'WorldPayCSE/WorldPayCSE/WorldPayCSE.h', \
                               'WorldPayCSE/WorldPayCSE/WPErrorCodes.h', \
                               'WorldPayCSE/WorldPayCSE/WPConstants.h', \
                               'WorldPayCSE/WorldPayCSE/crypto/WPPublicKey.h', \
                               'WorldPayCSE/WorldPayCSE/model/WPCardData.h'
  end

  s.subspec "OpenSSL" do |openssl|
    openssl.vendored_frameworks = 'WorldPayCSE/Thirdparty/OpenSSL/openssl.framework'
  end
end
