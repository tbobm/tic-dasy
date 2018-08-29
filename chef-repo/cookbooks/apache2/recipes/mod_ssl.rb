#
# Cookbook:: apache2
# Recipe:: mod_ssl
#
# Copyright:: 2008-2017, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if node['apache']['listen'] == ['*:80']
  node.default['apache']['listen'] += ["*:#{node['apache']['mod_ssl']['port']}"]
end

include_recipe 'apache2::default'

if platform_family?('rhel', 'fedora', 'suse', 'amazon')
  package node['apache']['mod_ssl']['pkg_name'] do
    notifies :run, 'execute[generate-module-list]', :immediately
    not_if { platform_family?('suse') }
  end

  file "#{apache_dir}/conf.d/ssl.conf" do
    content '# SSL Conf is under mods-available/ssl.conf - apache2 cookbook\n'
    only_if { ::Dir.exist?("#{apache_dir}/conf.d") }
  end
end

apache_module 'ports' do
  conf true
end

apache_module 'ssl' do
  conf true
end

include_recipe 'apache2::mod_socache_shmcb'
