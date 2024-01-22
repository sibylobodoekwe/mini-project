[webservers]
{{- range $index, $element := .instances }}
{{ $element.private_ip }} ansible_user=ec2-user
{{- end }}

[webservers:vars]
ansible_python_interpreter=/usr/