local access = require "kong.plugins.upstream-google-id-token.access"
local json = require "cjson"

-- If you're not sure your plugin is executing, uncomment the line below and restart Kong
-- then it will throw an error which indicates the plugin is being loaded at least.

-- assert(ngx.get_phase() == "timer", "The world is coming to an end!")

---------------------------------------------------------------------------------------------
-- In the code below, just remove the opening brackets; `[[` to enable a specific handler
--
-- The handlers are based on the OpenResty handlers, see the OpenResty docs for details
-- on when exactly they are invoked and what limitations each handler has.
---------------------------------------------------------------------------------------------

local plugin = {
    PRIORITY = 1000, -- set the plugin priority, which determines plugin execution order
    VERSION = "1.0.0" -- version in X.Y.Z format. Check hybrid-mode compatibility requirements.
}

-- do initialization here, any module level code runs in the 'init_by_lua_block',
-- before worker processes are forked. So anything you add here will run once,
-- but be available in all workers.
local path_to_sa_json = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
if (path_to_sa_json) then
    kong.log.info("GOOGLE_APPLICATION_CREDENTIALS: " .. path_to_sa_json)
    local fh = assert(io.open(path_to_sa_json, "r"), "Inaccessible sa file: " .. path_to_sa_json)
    local contents = fh:read("*a")
    google_application_credentials = json.decode(contents)
    assert(google_application_credentials["type"] == "service_account",
        "Key 'type' not found or value not equal to 'service_account' in " .. path_to_sa_json)
    fh:close()
else
    kong.log.notice("GOOGLE_APPLICATION_CREDENTIALS not set")
    google_application_credentials = nil
end

--[[ handles more initialization, but AFTER the worker process has been forked/created.
-- It runs in the 'init_worker_by_lua_block'
function plugin:init_worker()

    -- your custom code here
    kong.log.debug("saying hi from the 'init_worker' handler")

end -- ]]

--[[ runs in the 'ssl_certificate_by_lua_block'
-- IMPORTANT: during the `certificate` phase neither `route`, `service`, nor `consumer`
-- will have been identified, hence this handler will only be executed if the plugin is
-- configured as a global plugin!
function plugin:certificate(plugin_conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'certificate' handler")

end --]]

--[[ runs in the 'rewrite_by_lua_block'
-- IMPORTANT: during the `rewrite` phase neither `route`, `service`, nor `consumer`
-- will have been identified, hence this handler will only be executed if the plugin is
-- configured as a global plugin!
function plugin:rewrite(plugin_conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'rewrite' handler")

end --]]

-- runs in the 'access_by_lua_block'
function plugin:access(plugin_conf)

    -- your custom code here
    -- kong.log.inspect(plugin_conf) -- check the logs for a pretty-printed config!
    access.execute(plugin_conf)

end -- ]]

--[[ runs in the 'body_filter_by_lua_block'
function plugin:body_filter(plugin_conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'body_filter' handler")

end --]]

--[[ runs in the 'log_by_lua_block'
function plugin:log(plugin_conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'log' handler")

end --]]

-- return our plugin object
return plugin
