{{ required "Require nodeos value." .Values.nodeos }}
{{ required "Require nodeos.config value." .Values.nodeos.config }}
{{ required "Requires nodeos.plugin value." .Values.nodeos.plugin }}
{{ required "Requires nodeos.plugin.chain value." .Values.nodeos.plugin.chain }}
{{ required "Requires nodeos.plugin.http value." .Values.nodeos.plugin.http }}
{{ required "Requires nodeos.plugin.net value." .Values.nodeos.plugin.net }}
{{ required "Requires nodeos.plugin.producer value." .Values.nodeos.plugin.producer }}

{{- define "nodeos.arg_list" -}}
--data-dir {{ default "/mnt/dev/data" .Values.nodeos.config.data_dir }}

--plugin eosio::chain_api_plugin
--genesis-json {{ default "/root/.local/share/eosio/nodeos/config/genesis.json" .Values.nodeos.plugin.chain.genesis_json }}
--wasm-runtime {{ default "eos-vm-jit" .Values.nodeos.plugin.chain.wasm_runtime }}

--plugin eosio::http_plugin
--http-server-address {{ default "0.0.0.0:8080" .Values.nodeos.plugin.http.http_server_address }}
--http-validate-host {{ default 0 .Values.nodeos.plugin.http.http_validate_host }}

{{- if .Values.nodeos.plugin.net.agent_name }}
--agent-name {{ .Values.nodeos.plugin.net.agent_name }}
{{- end }}
{{- if .Values.nodeos.plugin.chain.disable_replay_opts }}
--disable-replay-opts
{{- end }}
{{- if .Values.nodeos.plugin.net.max_clients }}
--max-clients {{ .Values.nodeos.plugin.net.max_clients }}
{{- end }}
--p2p-accept-transactions {{ default true .Values.nodeos.plugin.net.p2p_accept_transactions }}
--p2p-listen-endpoint {{ default "0.0.0.0:8081" .Values.nodeos.plugin.net.p2p_listen_endpoint }}
{{- if .Values.nodeos.plugin.net.p2p_max_nodes_per_host }}
--p2p-max-nodes-per-host {{ .Values.nodeos.plugin.net.p2p_max_nodes_per_host }}
{{- end }}

--plugin eosio::producer_api_plugin
--plugin eosio::producer_plugin
{{- if .Values.nodeos.plugin.producer.enable_stale_production }}
--enable-stale-production
{{- end }}
--max-irreversible-block-age {{ default -1 .Values.nodeos.plugin.producer.max_irreversible_block_age }}
--producer-name {{ default "eosio" .Values.nodeos.plugin.producer.producer_name }}
{{- end -}}

{{- define "nodeos.args" -}}
{{ include "nodeos.arg_list" . | replace "\n" " " }}
{{- end -}}

{{- define "nodeos.command" -}}
{{ printf "nodeos %s" (include "nodeos.args" .) | quote }}
{{- end -}}
