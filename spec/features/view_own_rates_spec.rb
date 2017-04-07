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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe 'Only see your own rates', type: :feature, js: true do
  let(:project) { work_package.project }
  let(:user) { FactoryGirl.create :user,
                                  member_in_project: project,
                                  member_through_role: role }
  let(:role) { FactoryGirl.create :role, permissions: [:view_own_hourly_rate,
                                                       :view_work_packages,
                                                       :view_work_packages,
                                                       :view_own_time_entries,
                                                       :view_own_cost_entries,
                                                       :view_cost_rates,
                                                       :log_costs] }
  let(:work_package) {FactoryGirl.create :work_package }
  let(:wp_page) { ::Pages::FullWorkPackage.new(work_package) }
  let(:hourly_rate) { FactoryGirl.create :default_hourly_rate, user: user,
                                                               rate: 10.00 }
  let(:time_entry) { FactoryGirl.create :time_entry, user: user,
                                                     work_package: work_package,
                                                     project: project,
                                                     hours: 1.00 }
  let(:cost_type) {
    type = FactoryGirl.create :cost_type, name: 'Translations'
    FactoryGirl.create :cost_rate, cost_type: type,
                                   rate: 7.00
    type
  }
  let(:cost_entry) { FactoryGirl.create :cost_entry, work_package: work_package,
                                                     project: project,
                                                     units: 2.00,
                                                     cost_type: cost_type,
                                                     user: user }
  let(:other_role) { FactoryGirl.create :role, permissions: [] }
  let(:other_user) { FactoryGirl.create :user,
                                        member_in_project: project,
                                        member_through_role: other_role }
  let(:other_hourly_rate) { FactoryGirl.create :default_hourly_rate, user: other_user,
                                                                     rate: 11.00 }
  let(:other_time_entry) { FactoryGirl.create :time_entry, user: other_user,
                                                           hours: 3.00,
                                                           project: project,
                                                           work_package: work_package }
  let(:other_cost_entry) { FactoryGirl.create :cost_entry, work_package: work_package,
                                                           project: project,
                                                           units: 5.00,
                                                           user: other_user,
                                                           cost_type: cost_type }

  before do
    login_as(user)

    work_package
    hourly_rate
    time_entry
    cost_entry
    other_hourly_rate
    other_time_entry
    other_cost_entry

    wp_page.visit!
    wp_page.ensure_page_loaded
  end

  it 'only displays own entries and rates' do
    # All the values do not include the entries made by the other user
    wp_page.expect_attributes spent_time: '1 hour',
                              costs_by_type: '2 Translations',
                              overall_costs: '24.00 EUR',
                              labor_costs: '10.00 EUR',
                              material_costs: '14.00 EUR'
  end
end
