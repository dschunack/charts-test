{{/*
Define unique bucket Name. Can be changed with value.
*/}}

{{- define "bucket.name" -}}
{{- default (printf "loki-chunk-%s-%s" $.Values.clusterName ($.Values.accountId | toString) ) .Values.bucketName }}
{{- end }}

