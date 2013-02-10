{application,nodehalla_websocket,
             [{description,"Nodehalla websockets implementation."},
              {vsn,"0.1.0"},
              {modules,[nodehalla_websocket,nodehalla_websocket_sup,
                        websocket_handler]},
              {registered,[nodehalla_websocket_sup]},
              {applications,[kernel,stdlib,cowboy]},
              {mod,{nodehalla_websocket,[]}},
              {env,[]}]}.
