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

class UserNotifier < ActionMailer::Base
	include ConfigurationHelper

	default :from => AppConfig.mail_from

	def signup_notification(user)
		setup_email(user)
		@subject	+= I18n.t('users.email.signup', site_name: site_name)
		@url		= activate_url(user.activation_code)

		mail :to => user.email, :subject => @subject
	end

	def invitation_notification(invitation)
		setup_email(nil)
		@subject	+= I18n.t('users.email.invitation', site_name: site_name)
		@url		= signup_url(token: invitation.token)
		@invitation	= invitation

		mail :to => invitation.email, :subject => @subject
	end

	def password_reset_notification(user, new_password)
		setup_email(user)
		@subject += I18n.t 'users.email.password reset'
		@url			= root_url
		@new_password = new_password

		mail :to => user.email, :subject => @subject
	end

	protected
	def setup_email(user)
		@subject		= "#{I18n.t 'users.email.prefix', site_name_short: site_name(short: true)} "
		@sent_on		= Time.now
		@user			= user
	end

	def default_url_options
		super.merge(AppConfig.mail_url_options.symbolize_keys)
	end
end
