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

class AddJournalColumnsToTimeEntryJournals < ActiveRecord::Migration
  def change
    add_column :time_entry_journals, :overridden_costs, :decimal, precision: 15, scale: 2, null: true
    add_column :time_entry_journals, :costs, :decimal, precision: 15, scale: 2, null: true
    add_column :time_entry_journals, :rate_id, :integer
    Journal::TimeEntryJournal.reset_column_information
  end
end
