{{- define "nodeos.arg_list" -}}
--data-dir {{ default "/mnt/dev/data" .Values.global.nodeos.config.data_dir }}
--logconf {{ default "/root/.local/share/eosio/nodeos/config/log/logging.json" .Values.global.nodeos.config.logconf }}

--plugin eosio::chain_api_plugin
--genesis-json {{ default "/root/.local/share/eosio/nodeos/config/genesis.json" .Values.global.nodeos.plugin.chain.genesis_json }}
--wasm-runtime {{ default "eos-vm-jit" .Values.global.nodeos.plugin.chain.wasm_runtime }}

--plugin eosio::http_plugin
--http-server-address {{ default "0.0.0.0:8080" .Values.global.nodeos.plugin.http.http_server_address }}
--http-validate-host {{ default 0 .Values.global.nodeos.plugin.http.http_validate_host }}

{{- if .Values.global.nodeos.plugin.net.agent_name }}
--agent-name {{ .Values.global.nodeos.plugin.net.agent_name }}
{{- end }}
{{- if .Values.global.nodeos.plugin.chain.disable_replay_opts }}
--disable-replay-opts
{{- end }}
{{- if .Values.global.nodeos.plugin.net.max_clients }}
--max-clients {{ .Values.global.nodeos.plugin.net.max_clients }}
{{- end }}
--p2p-accept-transactions {{ default true .Values.global.nodeos.plugin.net.p2p_accept_transactions }}
--p2p-listen-endpoint {{ default "0.0.0.0:8081" .Values.global.nodeos.plugin.net.p2p_listen_endpoint }}
{{- if .Values.global.nodeos.plugin.net.p2p_max_nodes_per_host }}
--p2p-max-nodes-per-host {{ .Values.global.nodeos.plugin.net.p2p_max_nodes_per_host }}
{{- end }}

--plugin eosio::producer_api_plugin
{{- if .Values.global.nodeos.plugin.producer.enable_stale_production }}
--enable-stale-production
{{- end }}
{{- if .Values.global.nodeos.plugin.producer.max_irreversible_block_age }}
--max-irreversible-block-age .Values.global.nodeos.plugin.producer.max_irreversible_block_age
{{- end }}
{{- if .Values.global.nodeos.plugin.producer.max_transaction_time }}
--max-transaction-time .Values.global.nodeos.plugin.producer.max_transaction_time
{{- end }}
--producer-name {{ default "eosio" .Values.global.nodeos.plugin.producer.producer_name }}
{{- end -}}

{{- define "nodeos.args" -}}
{{ include "nodeos.arg_list" . | replace "\n" " " }}
{{- end -}}

{{- define "nodeos.command" -}}
{{ printf "nodeos %s" (include "nodeos.args" .) | quote }}
{{- end -}}
