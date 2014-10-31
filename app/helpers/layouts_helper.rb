module LayoutsHelper
	def navitab(text, url, active, &bl)
		li_opts = {}
		li_opts[:id] = 'active' if active
		if not bl.present?
			content_tag(:li, link_to(text, url), **li_opts)
		else
			li_opts[:class] = [li_opts[:class], 'submenu'].compact.join(' ')
			submenu = content_tag(:ul, capture(&bl), class: 'submenu wsite-menu-default')
			content_tag(:li, link_to(text, url) + submenu, **li_opts)
		end
	end

	def page_title
		page_title = AppConfig.site_name.untaint
		page_title += " - #{h @title}" if @title
		page_title
	end
end
