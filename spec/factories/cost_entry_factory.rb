#-- copyright
# OpenProject Costs Plugin
#
# Copyright (C) 2009 - 2014 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#++

FactoryGirl.define do
  factory :cost_entry  do
    project
    user do FactoryGirl.create(:user, member_in_project: project)end
    work_package do FactoryGirl.create(:work_package, project: project) end
    cost_type
    spent_on Date.today
    units 1
    comments ''
    created_on do Time.now end
    updated_on { Time.now }
  end
end
