class PeopleController < ApplicationController
  before_action :set_person, only: [:show]

  etag { can? :manage, Entity } # Don't cache admin content together with the rest

  # GET /people
  # GET /people.json
  def index
    @title = 'Osoby'
    @people = (can? :manage, Entity) ? Entity.people : Entity.people.published
    if stale?(last_modified: @people.maximum(:updated_at), :public => current_user.nil?)
      @people = @people.order("updated_at DESC").page(params[:page]).per(12)
    end
  end

  # GET /people/1
  # GET /people/1.json
  def show
    authorize! :read, @person
    if stale?(@people, :public => current_user.nil?)
      @title = @person.short_or_long_name
      @relations = []
      if(can? :manage, Entity)
        @person.relations
      else
        @person.relations.published.map{|e| if e.target.published && e.source.published then @relations.push e end}
      end

      embed_url = url_for controller: 'relation_visualizations', action: 'show', id: @person.slug
      @embed = "<iframe width='600' height='475' src='#{embed_url}'></iframe>"

      # Facebook Open Graph metadata
      @fb_description = @person.description unless @person.description.blank?
      @fb_image_url = @person.avatar.url() unless @person.avatar.nil?
    end
  end

  private
    def set_person
      @person = Entity.people
                      .includes(:related_posts, :related_photos, :mentions)
                      .find_by_slug!(params[:id])
    end
end
