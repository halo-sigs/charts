{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "halo.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}
{{- define "halo.mysql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "mysql" "chartValues" .Values.mysql "context" $) -}}
{{- end -}}

{{/*
Return the proper Halo image name
*/}}
{{- define "halo.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "halo.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "halo.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "halo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "halo.databasePlatform" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" "postgresql" -}}
{{- else if .Values.mysql.enabled -}}
    {{- printf "%s" "mysql" -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.platform -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database Hostname
*/}}
{{- define "halo.databaseHost" -}}
{{- if .Values.postgresql.enabled }}
    {{- if eq .Values.postgresql.architecture "replication" }}
        {{- printf "%s-primary" (include "halo.postgresql.fullname" .) | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "halo.postgresql.fullname" .) -}}
    {{- end -}}
{{- else if .Values.mysql.enabled }}
    {{- if eq .Values.mysql.architecture "replication" }}
        {{- printf "%s-primary" (include "halo.mysql.fullname" .) | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "halo.mysql.fullname" .) -}}
    {{- end -}}    
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database Port
*/}}
{{- define "halo.databasePort" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%d" (default 5432 .Values.postgresql.primary.service.ports.postgresql | int) -}}
{{- else if .Values.mysql.enabled }}
    {{- printf "%d" (default 3306 .Values.mysql.primary.service.ports.mysql | int) -}}    
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database Name
*/}}
{{- define "halo.databaseName" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" .Values.postgresql.auth.database -}}
{{- else if .Values.mysql.enabled }}
    {{- printf "%s" .Values.mysql.auth.database -}}    
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database User
*/}}
{{- define "halo.databaseUser" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" (default "halo" .Values.postgresql.auth.username) -}}
{{- else if .Values.mysql.enabled }}
    {{- printf "%s" (default "halo" .Values.mysql.auth.username) -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database Secret Name
*/}}
{{- define "halo.databaseSecretName" -}}
{{- if .Values.postgresql.enabled }}
    {{- if .Values.postgresql.auth.existingSecret -}}
        {{- printf "%s" .Values.postgresql.auth.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "halo.postgresql.fullname" .) -}}
    {{- end -}}
{{- else if .Values.mysql.enabled }}
    {{- if .Values.mysql.auth.existingSecret -}}
        {{- printf "%s" .Values.mysql.auth.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "halo.mysql.fullname" .) -}}
    {{- end -}}    
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.externalDatabase.existingSecret "context" $) -}}
{{- else -}}
    {{- printf "%s-externaldb" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database Secret Name
*/}}
{{- define "halo.databaseSecretKeyName" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "password" -}}
{{- else if .Values.mysql.enabled }}
    {{- printf "mysql-password" -}}
{{- else -}}
    {{- printf "password" -}}
{{- end -}}
{{- end -}}

{{/*
Return the R2DBC URL
*/}}
{{- define "halo.r2dbcUrl" -}}
    {{- printf "r2dbc:pool:%s://%s:%s/%s" (include "halo.databasePlatform" .) (include "halo.databaseHost" .) (include "halo.databasePort" .) (include "halo.databaseName" .) -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "halo.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "halo.validateValues.database" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Halo - Database */}}
{{- define "halo.validateValues.database" -}}
{{- if and (.Values.mysql.enabled) (.Values.postgresql.enabled) -}}
halo: database
   You can only enable one database installation between PostgreSQL and MySQL.
{{- else if and (not .Values.mysql.enabled) (not .Values.postgresql.enabled) (or (empty .Values.externalDatabase.host) (empty .Values.externalDatabase.port) (empty .Values.externalDatabase.user) (empty .Values.externalDatabase.password) (empty .Values.externalDatabase.database)) -}}
halo: database
   You disable the PostgreSQL installation and the MySQL installation both, but you did not provide the required parameters
   to use an external database. To use an external database, please ensure you provide
   (at least) the following values:

       externalDatabase.host=DB_SERVER_HOST
       externalDatabase.port=DB_SERVER_PORT
       externalDatabase.user=DB_SERVER_USER
       externalDatabase.password=DB_SERVER_PASSWORD
       externalDatabase.database=DB_NAME
{{- end -}}
{{- end -}}

