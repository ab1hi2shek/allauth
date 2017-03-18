class TagsController < ApplicationController
	load_and_authorize_resource

	def show
  		@tag = Tag.find(params[:id])
	end


end
