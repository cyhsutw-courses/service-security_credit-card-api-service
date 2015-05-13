# create user table
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      # password related
      t.string :hashed_password
      t.string :password_salt
      t.string :email
      t.string :fullname
      t.text :address
      t.date :dob
    end
  end
end
