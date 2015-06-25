# http://blog.paulrugelhiatt.com/ruby/rails/2014/10/27/rails-admin-custom-action-example.html
module RailsAdmin
  module Config
    module Actions
      class DeleteAndBlacklist < RailsAdmin::Config::Actions::Base
        # This ensures the action only shows up for Relations
        register_instance_option :visible? do
          authorized? && bindings[:object].class == Entity
        end
        # We want the action on members, not the Users collection
        register_instance_option :member do
          true
        end
        register_instance_option :link_icon do
          'icon-ban-circle'
        end
        # You may or may not want pjax for your action
        register_instance_option :pjax? do
          false
        end
        register_instance_option :controller do
          Proc.new do
            if @object.is_a?(Entity) && !@object.person
              @object.delete_and_blacklist
              flash[:success] = "Blacklisting done for organization: #{@object.name}"
              redirect_to back_or_index
            else
              @result = "ERROR! Blacklisting works only on Organizations"
              render :view => :delete_and_blacklist
            end
          end
        end
      end
    end
  end
end
