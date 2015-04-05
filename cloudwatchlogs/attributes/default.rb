case node['platform']
when 'amazon' then
  default['cloudwatchlogs']['awslogs_conf'] = '/etc/awslogs/awslogs.conf' 
  default['cloudwatchlogs']['awscli_conf']  = '/etc/awslogs/awscli.conf' 
when 'redhat', 'centos', 'fedora' then 
  default['cloudwatchlogs']['awslogs_conf'] = '/var/awslogs/etc/awslogs.conf'
  default['cloudwatchlogs']['awscli_conf']  = '/var/awslogs/etc/aws.conf'
end

default['cloudwatchlogs']['region']         = 'ap-northeast-1'
