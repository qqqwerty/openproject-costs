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

require File.dirname(__FILE__) + '/../spec_helper'

describe CostObjectsHelper, type: :helper do
  let(:project) { FactoryGirl.build(:project) }
  let(:cost_object) { FactoryGirl.build(:cost_object, project: project) }

  describe '#cost_objects_to_csv' do
    describe 'WITH a list of one cost object' do
      it 'should output the cost objects attributes' do
        expected = [cost_object.id,
                    cost_object.project.name,
                    cost_object.subject,
                    cost_object.author.name,
                    helper.format_date(cost_object.fixed_date),
                    helper.number_to_currency(cost_object.material_budget),
                    helper.number_to_currency(cost_object.labor_budget),
                    helper.number_to_currency(cost_object.spent),
                    helper.format_time(cost_object.created_on),
                    helper.format_time(cost_object.updated_on),
                    cost_object.description
                   ].join(I18n.t(:general_csv_separator))

        expect(cost_objects_to_csv([cost_object]).include?(expected)).to be_truthy
      end

      it 'should start with a header explaining the fields' do
        expected = ['#',
                    Project.model_name.human,
                    CostObject.human_attribute_name(:subject),
                    CostObject.human_attribute_name(:author),
                    CostObject.human_attribute_name(:fixed_date),
                    VariableCostObject.human_attribute_name(:material_budget),
                    VariableCostObject.human_attribute_name(:labor_budget),
                    CostObject.human_attribute_name(:spent),
                    CostObject.human_attribute_name(:created_on),
                    CostObject.human_attribute_name(:updated_on),
                    CostObject.human_attribute_name(:description)
                   ].join(I18n.t(:general_csv_separator))

        expect(cost_objects_to_csv([cost_object]).start_with?(expected)).to be_truthy
      end
    end
  end
end
