# ghetto require, since mruby doesn't have require
eval(File.read('/app/bin/config/lib/nginx_config_util.rb'))

USER_CONFIG = "/app/headers.json"

print 'printing /app/headers.json =>', File.read(USER_CONFIG)

config = {}
config = JSON.parse(File.read(USER_CONFIG)) if File.exist?(USER_CONFIG)
req    = Nginx::Request.new
uri    = req.var.uri

print 'printing req.var', req.var
print 'printing req', req
print 'printing $host', $host

if config
  config.to_a.reverse.each do |route, header_hash|
    print 'in config loop => route:', route
    print 'in config loop => uri:', uri
    if Regexp.compile("^#{NginxConfigUtil.to_regex(route)}$") =~ uri
        print 'match between route and uri'
        header_hash.each do |key, value|
            if key == "Set-Cookies"
                print 'value for Set-Cookies:', value
                req.headers_out[key] = value
            else
                # value must be a string
                req.headers_out[key] = value.to_s
            end
        end
        break
    end
  end
end
