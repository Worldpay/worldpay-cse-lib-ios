Pod::Spec.new do |s|
  s.name              = 'WorldpayCSE'
  s.version           = '1.0.3'
  s.summary           = 'Worldpay Client Side Encryption library'
  s.license           = { :type => 'Worldpay', :file => 'LICENSE' }
  s.author            = 'Worldpay'
  s.homepage          = 'https://github.com/Worldpay/worldpay-cse-lib-ios'
  s.description       = 'Worldpay Client Side encryption library for easy integration with your existing and new applications.'
  s.documentation_url = 'http://support.worldpay.com/support/kb/gg/client-side-encryption/Content/A%20-%20Home/Home.htm'

  s.source            = { :git => 'https://github.com/Worldpay/worldpay-cse-lib-ios.git', :tag => s.version  }

  s.platform          = :ios, '7.0'

  # OpenSSL is not following semantic versioning very well, so better pin here the
  # version that we know works 100%
  #
  # See: https://wiki.openssl.org/index.php/OpenSSL_1.1.0_Changes (by making some
  # structs opaque they introduced breaking changes in a minor release)
  s.dependency 'OpenSSL-Universal', '1.1.1100'
  s.source_files        = 'WorldPayCSE/WorldPayCSE/**/*.{h,m}'
  s.public_header_files = 'WorldPayCSE/WorldPayCSE/WorldPayCSE.h', \
                          'WorldPayCSE/WorldPayCSE/WPErrorCodes.h', \
                          'WorldPayCSE/WorldPayCSE/WPConstants.h', \
                          'WorldPayCSE/WorldPayCSE/crypto/WPPublicKey.h', \
                          'WorldPayCSE/WorldPayCSE/model/WPCardData.h'

  s.test_spec 'Tests' do |ts|
    ts.dependency 'OCMock', '3.8.1'
    ts.source_files = "WorldpayCSE/WorldpayCSETests/**/*.{m,h}"
  end
end
