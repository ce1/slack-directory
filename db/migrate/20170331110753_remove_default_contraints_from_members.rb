class RemoveDefaultContraintsFromMembers < ActiveRecord::Migration
  def change
    change_column :members, :email, :string, :null => true
    change_column :members, :uid, :string, :null => false
  end
end
