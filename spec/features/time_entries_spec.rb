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

describe 'Work Package table cost sums', type: :feature, js: true do
  let(:project) { FactoryGirl.create :project }
  let(:user) { FactoryGirl.create :admin }

  let(:parent) { FactoryGirl.create :work_package, project: project }
  let(:work_package) { FactoryGirl.create :work_package, project: project, parent: parent }
  let(:hourly_rate) { FactoryGirl.create :default_hourly_rate, user: user, rate: 1.00 }

  let!(:time_entry1) {
    FactoryGirl.create :time_entry,
                       user: user,
                       work_package: parent,
                       project: project,
                       hours: 10
  }

  let!(:time_entry2) {
    FactoryGirl.create :time_entry,
                       user: user,
                       work_package: work_package,
                       project: project,
                       hours: 2.50
  }

  let(:wp_table) { ::Pages::WorkPackagesTable.new(project) }
  let!(:query) do
    query              = FactoryGirl.build(:query, user: user, project: project)
    query.column_names = %w(id subject spent_hours)

    query.save!
    query
  end

  before do
    login_as(user)

    wp_table.visit_query(query)
    wp_table.expect_work_package_listed(parent)
    wp_table.expect_work_package_listed(work_package)
  end

  it 'shows the correct sum of the time entries' do
    parent_row = wp_table.row(parent)
    wp_row = wp_table.row(work_package)

    expect(parent_row).to have_selector('.wp-edit-field.spentTime', text: '12.5 hours')
    expect(wp_row).to have_selector('.wp-edit-field.spentTime', text: '2.5 hours')
  end
end
