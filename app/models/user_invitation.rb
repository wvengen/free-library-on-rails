# Copyright 2014 wvengen
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

class UserInvitation < ActiveRecord::Base
	has_one :invited_by, class_name: 'User'
	
	validates :expires_at, presence: true
	validates :token, presence: true, uniqueness: true
	validates :email, length: { in: 3..100 }, format: { with: /(^([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i }

	after_initialize :set_defaults, if: :new_record?

	def valid_invitation?
		expires_at > Time.now
	end

	private

	def set_defaults
		self.token = SecureRandom.urlsafe_base64(12)
		self.expires_at = 1.week.from_now
	end
end
