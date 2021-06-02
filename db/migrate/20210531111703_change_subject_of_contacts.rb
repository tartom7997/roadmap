class ChangeSubjectOfContacts < ActiveRecord::Migration[6.1]
  def self.up
    change_column :contacts, :subject, :string, :null => false, :default => nil
  end
   
  def self.down
    change_column :contacts, :subject, :integer, :null => false, :default => 0
  end
end
