class LikeRoadmapsController < ApplicationController
    before_action :set_variables

    def like
      like = current_user.like_roadmaps.new(roadmap_id: @roadmap.id)
      like.save
      redirect_back(fallback_location: root_path)
    end
  
    def unlike
      like = current_user.like_roadmaps.find_by(roadmap_id: @roadmap.id)
      like.destroy
      redirect_back(fallback_location: root_path)
    end
  
    private
    def set_variables
      @roadmap = Roadmap.find(params[:roadmap_id])
    end

end
