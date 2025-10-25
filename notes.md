# Development Notes

## NNCPNet Environment Variable Shenanigans

### nncpnet-transmit
The use of `$HOST` was just for debug prints.  `$RECIPIENT` was due to Exim passing it to pipe transports through the environment.  Postfix passes `$recipient` as a command line argument when defining a pipe transport in master.cf so we don't need to pull it out of the environment in nncpnet-transmit.

### nncpnet-ingest
`NNCP_SENDER` is set by NNCP which invokes `nncpnet-ingest` on our behalf to convert NNCP packets into email and send them to localhost with Sendmail.  No changes are needed from Exim to Postfix.

## nncp-exec stuff

nncp-rmail-v1 is not a script in PATH, it's a handler in the nncp neighbor config file.  If it doesn't exist for self or quux, update the config from the nodelist.
