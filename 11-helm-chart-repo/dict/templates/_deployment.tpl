{{- define "mychart.deployment" -}}
{{- $component := .component -}}
{{- $valuesSection := .valuesSection -}}
{{- with (index $.ctx.Values $valuesSection) -}}
{{- if .enabled -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $component }}
spec:
  replicas: {{ if .replicaCount }}{{ .replicaCount }}{{ else }}{{ $.ctx.Values.global.replicaCount }}{{ end }}
  selector:
    matchLabels:
      app: {{ $component }}
  template:
    metadata:
      labels:
        app: {{ $component }}
    spec:
      containers:
        - name: {{ $component }}
          image: {{ .controller.image.repository }}:{{ .controller.image.tag }}
          imagePullPolicy: {{ $.ctx.Values.global.imagePullPolicy }}
{{- end -}}
{{- end -}}
{{- end -}}
