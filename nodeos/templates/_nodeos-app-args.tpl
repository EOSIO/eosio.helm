{{- define "nodeos.arg_list" -}}
--genesis-json /root/.local/share/eosio/nodeos/config/genesis.json
--http-validate-host=0
--max-irreversible-block-age=-1
--contracts-console
--logconf /root/.local/share/eosio/nodeos/config/log/logging.json
--signature-cpu-billable-pct=0
--last-block-cpu-effort-percent=100
--last-block-time-offset-us=0
--cpu-effort-percent=100
--produce-time-offset-us=0
--max-clients=10
--p2p-max-nodes-per-host=99999
--enable-stale-production
--disable-replay-opts
--agent-name 'block producer agent'
--sync-fetch-span=1000
--verbose-http-errors
--wasm eos-vm-jit
--plugin eosio::producer_plugin
--plugin eosio::producer_api_plugin
--plugin eosio::state_history_plugin
--trace-history
--chain-state-history
--state-history-endpoint=0.0.0.0:8082
--plugin eosio::chain_api_plugin
--plugin eosio::http_plugin
--producer-name eosio
--http-server-address=0.0.0.0:8080
--p2p-listen-endpoint=0.0.0.0:8081
--p2p-accept-transactions=true
--data-dir /mnt/dev/data
--abi-serializer-max-time-ms=1000000000
--max-body-size=1000000000
--max-transaction-time=475
--http-max-response-time-ms=1000000000
--access-control-allow-origin '*'
--access-control-allow-headers '*'
--access-control-allow-credentials
{{- end -}}

{{- define "nodeos.args" -}}
{{ include "nodeos.arg_list" . | replace "\n" " "}}
{{- end -}}

{{- define "nodeos.command" -}}
{{ printf "\"nodeos %s\""  (include "nodeos.args" .) }}
{{- end -}}
