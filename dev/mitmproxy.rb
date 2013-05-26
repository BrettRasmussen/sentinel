require 'webrick'
require 'webrick/ssl'
require 'webrick/httpproxy'

class WEBrick::HTTPRequest
  attr_reader :socket
end

class MitmProxyServer < WEBrick::HTTPProxyServer
  #def service(req, res)
    #if req.request_method == "CONNECT"
      #do_CONNECT(req, res)
    #elsif req.unparsed_uri =~ %r!^http://!
      #proxy_service(req, res)
    #else
      #super(req, res)
    #end
  #end

  def service(req, res)
    if req.request_method == "CONNECT"
      debugger
      @config[:SSLEnable] = true
      @ssl_context = setup_ssl_context({
        :SSLCertName => [['CN', 'twoedge.com']],
        :SSLCertComment => ""
      })
      super(req, res)
    else
      super(req, res)
    end
  end
end
