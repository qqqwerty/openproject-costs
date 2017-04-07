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

describe Project::Activity, type: :model do
  let(:project) do
    FactoryGirl.create(:project)
  end

  let(:initial_time) { Time.now }

  let(:cost_object) do
    FactoryGirl.create(:cost_object,
                       project: project)
  end

  let(:cost_object2) do
    FactoryGirl.create(:cost_object,
                       project: project)
  end

  let(:work_package) do
    FactoryGirl.create(:work_package,
                       project: project)
  end

  def latest_activity
    Project.with_latest_activity.find(project.id).latest_activity_at
  end

  describe '.with_latest_activity' do
    it 'is the latest cost_object update' do
      cost_object.update_attribute(:updated_on, initial_time - 10.seconds)
      cost_object2.update_attribute(:updated_on, initial_time - 20.seconds)
      cost_object.reload
      cost_object2.reload

      expect(latest_activity).to eql cost_object.updated_on
    end

    it 'takes the time stamp of the latest activity across models' do
      work_package.update_attribute(:updated_at, initial_time - 10.seconds)
      cost_object.update_attribute(:updated_on, initial_time - 20.seconds)

      work_package.reload
      cost_object.reload

      # Order:
      # work_package
      # cost_object

      expect(latest_activity).to eql work_package.updated_at

      work_package.update_attribute(:updated_at, cost_object.updated_on - 10.seconds)

      # Order:
      # cost_object
      # work_package

      expect(latest_activity).to eql cost_object.updated_on
    end
  end
end
