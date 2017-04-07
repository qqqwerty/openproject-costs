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

describe CostlogController, type: :routing do
  describe 'routing' do
    it {
      expect(get('/work_packages/5/cost_entries')).to route_to(controller: 'costlog',
                                                               action: 'index',
                                                               work_package_id: '5')
    }

    it {
      expect(get('/projects/blubs/cost_entries/new')).to route_to(controller: 'costlog',
                                                                  action: 'new',
                                                                  project_id: 'blubs')
    }

    it {
      expect(post('/projects/blubs/cost_entries')).to route_to(controller: 'costlog',
                                                               action: 'create',
                                                               project_id: 'blubs')
    }

    it {
      expect(get('/work_packages/5/cost_entries/new')).to route_to(controller: 'costlog',
                                                                   action: 'new',
                                                                   work_package_id: '5')
    }

    it {
      expect(get('/cost_entries/5/edit')).to route_to(controller: 'costlog',
                                                      action: 'edit',
                                                      id: '5')
    }

    it {
      expect(put('/cost_entries/5')).to route_to(controller: 'costlog',
                                                 action: 'update',
                                                 id: '5')
    }

    it {
      expect(delete('/cost_entries/5')).to route_to(controller: 'costlog',
                                                    action: 'destroy',
                                                    id: '5')
    }
  end
end
