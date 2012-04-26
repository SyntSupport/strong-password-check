require 'redmine'
require 'active_support'

require File.dirname(__FILE__) + '/lib/user_patch.rb'

require 'dispatcher'
Dispatcher.to_prepare :strong_password_check do
  require_dependency 'user'
  User.send(:include, StrongPasswordCheck::Patches::UserPatch)  
end

Redmine::Plugin.register :strong_password_check do
  name 'ChiliProject Strong password check'
  author 'Ilya Turkin'
  description 'Check for strong passwords'
  version '0.0.1'
  author_url 'https://github.com/SyntSupport'
end
