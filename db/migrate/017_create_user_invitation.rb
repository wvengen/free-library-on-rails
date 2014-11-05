class CreateUserInvitation < ActiveRecord::Migration
  def change
	  create_table :user_invitations do |t|
		  t.integer :invited_by_id
		  t.string :email
		  t.string :message
		  t.string :token, null: false
		  t.datetime :expires_at, null: false
		  t.datetime :created_at
	  end
	  add_index :user_invitations, :token, unique: true
  end
end
