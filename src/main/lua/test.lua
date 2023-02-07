local function main()
    local uri = ngx.var.uri
    ngx.say(uri)
end
main()