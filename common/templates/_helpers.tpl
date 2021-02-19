{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "common.name" -}}
eosio
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "common.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Common labels
*/}}
{{- define "common.labels" -}}
helm.sh/chart: {{ include "common.chart" . }}
{{ include "common.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}


{{/*
Selector labels
*/}}
{{- define "common.selectorLabels" -}}
app.kubernetes.io/branch: {{ .Values.global.branch }}
app.kubernetes.io/instance: {{ include "common.name" . }}-{{ .Values.global.instance }}
version: {{ .Values.global.branch }}
{{- end -}}


{{/*
Storage Class
*/}}
{{- define "common.storageClass" -}}
  {{- if eq .Values.global.cloudProvider "local" -}}
    hostpath
  {{- else if eq .Values.global.cloudProvider "aws" -}}
    gp2
  {{- else if eq .Values.global.cloudProvider "gcp" -}}
    standard
  {{- else }}
    {{ required (printf "Must provide a supported cloud provider [local, aws, gcp") nil }}
  {{- end -}}
{{- end -}}


{{/*
Generate container prefix
*/}}
{{- define "common.containerPrefix" -}}
  {{- if eq .containerRepo "dockerhub" -}}
    {{ .Values.global.containers.dockerhub }}
  {{- else }}
    {{ required (printf "Must provide a supported region") nil }}
  {{- end -}}
{{- end -}}


{{/*
Generate container
*/}}
{{- define "common.container" -}}
  {{- if eq .containerRepo "local" -}}
    {{- if .localImage -}}
      {{ .localImage }}
    {{- else if .Values.global.dryRun -}}
      local
    {{- else -}}
      {{ required (printf "Local source chosen but no image provided for the service.") nil }}
    {{- end -}}
  {{- else if (eq .containerRepo "dockerhub") -}}
    {{ include "common.containerPrefix" . }}/{{ .serviceName }}:{{ .containerTag }}
  {{- else -}}
    {{ required (printf "Must provide a valid source for image.") nil }}
  {{- end -}}
{{- end -}}


{{/*
Containers
*/}}
{{- define "common.initContainer" -}}
  {{ template "common.container" (dict "Values" .Values "containerRepo" .Values.global.containers.initContainer.containerRepo "containerTag" .Values.global.containers.initContainer.containerTag "serviceName" "init" "localImage" .Values.global.localInitImage ) }}
{{- end -}}

{{- define "common.nodeosContainer" -}}
  {{ template "common.container" (dict "Values" .Values "containerRepo" .Values.global.containers.eosio.containerRepo "containerTag" .Values.global.containers.eosio.containerTag "serviceName" "eosio" "localImage" .Values.global.localEosioImage ) }}
{{- end -}}


{{/*
Service names
*/}}
{{- define "common.nodeosName" -}}
{{ include "common.name" . }}-{{ .Values.global.instance }}-nodeos
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "common.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
