class RelationVisualizationsController < ApplicationController
  before_action :set_entity, only: [:show]

  def show
    authorize! :read, @entity
    if stale?(@entities, :public => current_user.nil?)
      @title = @entity.short_or_long_name
      @relations = (can? :manage, Entity) ? @entity.relations : @entity.relations.published
    end
  end

  private
  def set_entity
    @entity = Entity.all
      .includes(:related_posts, :related_photos, :mentions)
      .find_by_slug!(params[:id])
  end
end
