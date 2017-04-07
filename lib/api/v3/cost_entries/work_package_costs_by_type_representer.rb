#-- encoding: UTF-8
#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2015 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

module API
  module V3
    module CostEntries
      # Ripped from ::API::Decorators::Collection, which does not support injecting
      # decorators directly
      # This class should use the Collection class directly (or inherit from it) in the future
      class WorkPackageCostsByTypeRepresenter < ::API::Decorators::Single
        link :self do
          { href: api_v3_paths.summarized_work_package_costs_by_type(represented.id) }
        end

        property :total,
                 exec_context: :decorator,
                 getter: -> (*) { cost_helper.summarized_cost_entries.size }
        property :count,
                 exec_context: :decorator,
                 getter: -> (*) { cost_helper.summarized_cost_entries.size }

        collection :elements,
                   getter: -> (*) {
                     cost_helper.summarized_cost_entries.map { |kvp|
                       type = kvp[0]
                       units = kvp[1]
                       ::API::V3::CostEntries::AggregatedCostEntryRepresenter.new(type, units)
                     }
                   },
                   exec_context: :decorator,
                   embedded: true

        private

        def cost_helper
          @cost_helper ||= ::OpenProject::Costs::AttributesHelper.new(represented, current_user)
        end

        def _type
          'Collection'
        end
      end
    end
  end
end
