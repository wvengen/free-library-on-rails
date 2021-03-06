# Copyright 2009 Michael Edwards, Brendan Taylor
# This file is part of free-library-on-rails.
#
# free-library-on-rails is free software: you can redistribute it
# and/or modify it under the terms of the GNU Affero General Public
# License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.

# free-library-on-rails is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public
# License along with free-library-on-rails.
# If not, see <http://www.gnu.org/licenses/>.

class ItemsController < ApplicationController
	before_filter :login_required, :only => [ :new, :create, :destroy, :edit, :update ]

	def itemclass; Item end

	def index
		@title = itemclass.model_name.human.pluralize

		if params[:order].present? and ['author_last', 'author_first', 'owner_id'].member? params[:order]
			@order = params[:order]
		else
			# default to sort by title
			@order = 'title'
		end

		@items = region.items.
					where(:type => itemclass.to_s).
					order(@order).
					paginate(:page => params[:page], :per_page => 28) # 7x4=28, 4 rows of blocks
	end

	def show
		@item = itemclass.find(params[:id])
		@title = @item.title
	rescue ActiveRecord::RecordNotFound
		four_oh_four
	end

	def new
		@title = I18n.t('items.new.title', :item => itemclass.model_name.human)
		@item = itemclass.new(params[:item])

		@tags = params[:tags]
		@tags = @tags.strip.split(Taggable::TAG_SEPARATOR) if @tags.is_a? String
		@tags ||= []
	end

	def create
		@item = itemclass.new(params[:item])

		@item.created = Time.now
		@item.owner = current_user

		@item.save!

		@item.tag_with params[:tags] if params[:tags]

		redirect_to :controller => itemclass.to_s.tableize, :action => 'show', :id => @item
	end

	def edit
		@item = itemclass.find(params[:id])
		@title = I18n.t('item.edit.title', :item => @item.title)

		unless @item.owned_by?(current_user) or current_user.librarian?
			redirect_to polymorphic_path(@item)
		end
	rescue ActiveRecord::RecordNotFound
		four_oh_four
	end

	def update
		@item = itemclass.find(params[:id])

		unless @item.owned_by?(current_user) or current_user.librarian?
			unauthorized I18n.t('update.message.unauthorized'); return
		end

		itemclass.update(params[:id], params[:item])

		@item.tag_with params[:tags]

		redirect_to polymorphic_path(@item)
	end

	def destroy
		@item = Item.find(params[:id])

		unless @item.owned_by?(current_user)
			unauthorized I18n.t('destroy.message.unauthorized'); return
		end

		@item.destroy

		# XXX this has behaved weird anecdotally... come back to it and test
		#		-- i haven't noticed anything weird here. obsolete comment? (bct, 2009-09)
		redirect_to user_path(current_user.login)
	end

	# plain ?param=value parameters:
	#	q:		the search term
	#	field:	fields to search
	#	page:	pagination
	def search
		@query = params[:q]

		# fields to search
		@fields =	if params[:field].present?
						[ params[:field] ]
					else
						[ 'tags', 'title', 'author', 'description' ]
					end

		if @fields.member? 'tags'
			@tag_results = itemclass.find_by_tag(@query).paginate(:page => params[:page])
		end

		terms = @query.split(' ')

		if @fields.member? 'title'
			@title_results = itemclass.paginated_search_title params[:page], terms
		end

		if @fields.member? 'author'
			@author_results = itemclass.paginated_search_author params[:page], terms
		end

		if @fields.member? 'description'
			@description_results = itemclass.paginated_search_description params[:page], terms
		end
	end
end
