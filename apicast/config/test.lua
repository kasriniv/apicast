return {
    worker_processes = '1',
    master_process = 'off',
    daemon = 'on',
    error_log = '/Users/mikz/Developer/3scale/apicast/t/servroot/logs/error.log',
    log_level = 'debug',
    pid = '/Users/mikz/Developer/3scale/apicast/t/servroot/logs/nginx.pid',
    lua_code_cache = 'on',
    access_log = '/Users/mikz/Developer/3scale/apicast/t/servroot/logs/access.log',
    port = { apicast = '1984' },
}
