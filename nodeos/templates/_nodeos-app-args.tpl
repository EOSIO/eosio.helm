{{- define "nodeos.arg_list" -}}
--genesis-json {{ default "/root/.local/share/eosio/nodeos/config/genesis.json" .Values.nodeos.plugin.chain.genesis_json }}
--http-validate-host {{ default 0 .Values.nodeos.plugin.http.http_validate_host }}
--max-irreversible-block-age {{ default -1 .Values.nodeos.plugin.producer.max_irreversible_block_age }}
{{- if .Values.nodeos.plugin.net.max_clients -}}
--max-clients {{ .Values.nodeos.plugin.net.max_clients }}
{{- end -}}
{{- if .Values.nodeos.plugin.net.p2p_max_nodes_per_host -}}
--p2p-max-nodes-per-host {{ .Values.nodeos.plugin.net.p2p_max_nodes_per_host }}
{{- end -}}
{{- if .Values.nodeos.plugin.producer.enable_stale_production -}}
--enable-stale-production
{{- end -}}
{{- if .Values.nodeos.plugin.chain.disable_replay_opts -}}
--disable-replay-opts
{{- end -}}
{{- if .Values.nodeos.plugin.net.agent_name -}}
--agent-name {{ .Values.nodeos.plugin.net.agent_name }}
{{- end -}}
--wasm-runtime {{ default "eos-vm-jit" .Values.nodeos.plugin.chain.wasm_runtime }}
--plugin eosio::producer_plugin
--plugin eosio::producer_api_plugin
--plugin eosio::chain_api_plugin
--plugin eosio::http_plugin
--producer-name {{ default "eosio" .Values.nodeos.plugin.producer.producer_name }}
--http-server-address {{ default "0.0.0.0:8080" .Values.nodeos.plugin.http.http_server_address }}
--p2p-listen-endpoint {{ default "0.0.0.0:8081" .Values.nodeos.plugin.net.p2p_listen_endpoint }}
--p2p-accept-transactions {{ default true .Values.nodeos.plugin.net.p2p_accept_transactions }}
--data-dir {{ default "/mnt/dev/data" .Values.nodeos.config.data_dir }}
{{- end -}}

{{- define "nodeos.args" -}}
{{ include "nodeos.arg_list" . | replace "\n" " " }}
{{- end -}}

{{- define "nodeos.command" -}}
{{ printf "nodeos %s"  (include "nodeos.args" .) }}
{{- end -}}
