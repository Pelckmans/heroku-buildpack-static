# ghetto require, since mruby doesn't have require
eval(File.read('/app/bin/config/lib/nginx_config_util.rb'))

USER_CONFIG = "/app/headers.json"

print 'printing /app/headers.json =>', File.read(USER_CONFIG)

config = {}
config = JSON.parse(File.read(USER_CONFIG)) if File.exist?(USER_CONFIG)
req    = Nginx::Request.new
uri    = req.var.uri

if config
  config.to_a.reverse.each do |route, header_hash|
    if Regexp.compile("^#{NginxConfigUtil.to_regex(route)}$") =~ uri
        header_hash.each do |key, value|
            if key == "Set-Cookie"
                value.each do |cookieValue|
                    print 'inside cookie loop =>', cookieValue.to_s
                    # value must be a string
                    req.headers_out[key] = cookieValue.to_s
                end
            else
                # value must be a string
                req.headers_out[key] = value.to_s
            end
        end
        break
    end
  end
end
