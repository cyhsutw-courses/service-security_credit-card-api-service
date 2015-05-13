# create user table
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false, unique: true
      # password related
      t.string :hashed_password, null: false
      t.string :password_salt, null: false
      t.string :email, null: false
      t.string :fullname, null: false
      t.text :address, null: false
      t.date :dob, null: false
    end
  end
end
