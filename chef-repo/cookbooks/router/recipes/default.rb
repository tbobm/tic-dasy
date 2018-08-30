#
# Cookbook:: router
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
ip_tables = '/etc/network/ip-up.d/iptables'

execute 'ip_forward' do
    command ip_tables
    action :nothing
end

template ip_tables do
    source 'iptables'
    owner 'root'
    group 'root'
    mode '0755'
    notifies :run, 'execute[ip_forward]', :immediately
end
