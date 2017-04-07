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
  let(:role) { FactoryGirl.create :role, permissions: [:view_work_packages,
                                                       :delete_work_packages,
                                                       :edit_cost_entries,
                                                       :view_cost_entries] }
  let(:work_package) {FactoryGirl.create :work_package }
  let(:other_work_package) {FactoryGirl.create :work_package, project: project }
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

  it 'allows to move the time entry to a different work package' do
    allow(User).to receive(:current).and_return(user)

    work_package
    other_work_package
    cost_entry

    wp_page = Pages::FullWorkPackage.new(work_package)
    wp_page.visit!

    find('#action-show-more-dropdown-menu').click();

    click_link(I18n.t('js.button_delete'))

    wp_page.accept_alert_dialog!

    fill_in 'to_do_reassign_to_id', :with => other_work_package.id

    click_button(I18n.t('button_delete'))

    other_wp_page = Pages::FullWorkPackage.new(other_work_package)
    other_wp_page.visit!

    wp_page.expect_attributes costs_by_type: '2 Translations'
  end
end
