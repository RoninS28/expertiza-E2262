# frozen_string_literal: true

class CreateInstitutions < ActiveRecord::Migration[4.2]
  def self.up
    create_table :institutions do |t|
      t.column :name, :string # printname of institution (college, university, high school, etc.)
    end
  end

  def self.down
    drop_table :institutions
  end
end
