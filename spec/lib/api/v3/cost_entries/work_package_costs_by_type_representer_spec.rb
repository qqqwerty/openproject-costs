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

require 'spec_helper'

describe ::API::V3::CostEntries::WorkPackageCostsByTypeRepresenter do
  include API::V3::Utilities::PathHelper

  let(:project) { FactoryGirl.create(:project) }
  let(:work_package) { FactoryGirl.create(:work_package, project: project) }
  let(:cost_type_A) { FactoryGirl.create(:cost_type) }
  let(:cost_type_B) { FactoryGirl.create(:cost_type) }
  let(:cost_entries_A) {
    FactoryGirl.create_list(:cost_entry,
                            2,
                            units: 1,
                            work_package: work_package,
                            project: project,
                            cost_type: cost_type_A)
  }
  let(:cost_entries_B) {
    FactoryGirl.create_list(:cost_entry,
                            3,
                            units: 2,
                            work_package: work_package,
                            project: project,
                            cost_type: cost_type_B)
  }
  let(:current_user) {
    FactoryGirl.build(:user, member_in_project: project, member_through_role: role)
  }
  let(:role) { FactoryGirl.build(:role, permissions: [:view_cost_entries]) }

  let(:representer) { described_class.new(work_package, current_user: current_user) }

  subject { representer.to_json }

  before do
    # create the lists
    cost_entries_A
    cost_entries_B
  end

  it 'has a type' do
    is_expected.to be_json_eql('Collection'.to_json).at_path('_type')
  end

  it 'has one element per type' do
    is_expected.to have_json_size(2).at_path('_embedded/elements')
  end

  it 'indicates the cost types' do
    elements = JSON.parse(subject)['_embedded']['elements']
    types = elements.map { |entry| entry['_links']['costType']['href'] }
    expect(types).to include(api_v3_paths.cost_type cost_type_A.id)
    expect(types).to include(api_v3_paths.cost_type cost_type_B.id)
  end

  it 'aggregates the units' do
    elements = JSON.parse(subject)['_embedded']['elements']
    units_by_type = elements.inject({}) { |hash, entry|
      hash[entry['_links']['costType']['href']] = entry['spentUnits']
      hash
    }

    expect(units_by_type[api_v3_paths.cost_type cost_type_A.id]).to eql 2.0
    expect(units_by_type[api_v3_paths.cost_type cost_type_B.id]).to eql 6.0
  end
end
