{{/* vim: set filetype=mustache: */}}
{{/*
创建默认的完全合格的应用程序名称，我们将其截断为 63 个字符，因为某些 Kubernetes 名称字段受此限制（根据 DNS 命名规范）
若 .Values.nameOverride 为空，则默认值为 .Chart.Name
*/}}
{{- define "roh5server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
如果release name包含chart名称，则将作为全名使用.
*/}}
{{- define "roh5server.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "roh5server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "roh5server.labels" -}}
helm.sh/chart: {{ include "roh5server.chart" . }}
{{ include "roh5server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "roh5server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "roh5server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

