class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :admin_users, :force => true do |t|
      t.string :login                     
      t.string :email                    
      t.string :crypted_password,          :limit => 40
      t.string :salt,                      :limit => 40          
      t.string :remember_token
      t.datetime :remember_token_expires_at
      t.timestamp :reset_password_expires_at
      t.string    :type
      t.boolean   :deleted
    end
    add_index :admin_users, :login
    insert("INSERT INTO admin_users (login,email,crypted_password,salt) VALUES('atbalsts@ithouse.lv','atbalsts@ithouse.lv','8f1b8f9504b34e63d560968be2448957ae38177e','f15c1dcd585628112cc4076f8dd31a877e342fce')")
 end

  def self.down
    drop_table :admin_users
  end
end
