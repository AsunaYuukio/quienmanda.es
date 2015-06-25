module RailsAdmin
  module Config
    module Actions
      class Import < RailsAdmin::Config::Actions::Base
        # This ensures the action only shows up for Relations
        register_instance_option :visible? do
          authorized? && bindings[:object].class == Entity
        end
        # We want the action on members, not the Users collection
        register_instance_option :member do
          true
        end
        register_instance_option :link_icon do
          'icon-download'
        end
        # You may or may not want pjax for your action
        register_instance_option :pjax? do
          false
        end
        register_instance_option :controller do
          Proc.new do
            if @object.is_a?(Entity) && @object.person
              importer = ImportPersonData.new(@object.id)
              importer.import_missing_pesels
              importer.import_historic_relations
              importer.import_current_relations
              @result = importer.result
              render :view => :import
            elsif @object.is_a?(Entity) && !@object.person
              importer = ImportCompanyData.new(@object.id)
              importer.import_missing_krs
              importer.import_heads
              @result = importer.result
              render :view => :import
            else
              @result = "ERROR! Import works only on Persons"
              render :view => :import
            end
          end
        end
      end
    end
  end
end

