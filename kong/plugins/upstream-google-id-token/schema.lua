local typedefs = require "kong.db.schema.typedefs"
local PLUGIN_NAME = "upstream-google-id-token"

local schema = {
    name = PLUGIN_NAME,
    fields = {{
        protocols = typedefs.protocols_http
    }, {
        config = {
            type = "record",
            fields = {{
                id_token_header_name = {
                    type = "string",
                    -- Use X-Serverless-Authorization header to pass the service account id token to the Cloud Run service
                    -- This allows us to still pass the app token in the Authorization header
                    -- https://cloud.google.com/run/docs/authenticating/service-to-service#acquire-token
                    default = "X-Serverless-Authorization"
                }
            }, {
                id_token_cache_ttl = {
                    type = "integer",
                    between = {0, 3600},
                    default = 3600 -- Google ID tokens are issued for one hour validity
                }
            }}
        }
    }}
}

return schema
