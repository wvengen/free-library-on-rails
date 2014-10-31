module LayoutsHelper
	def navitab(text, url, active)
		li_opts = {}
		li_opts[:id] = 'active' if active
		content_tag(:li, link_to(text, url), **li_opts)
	end

	def page_title
		page_title = AppConfig.site_name.untaint
		page_title += " - #{h @title}" if @title
		page_title
	end
end
