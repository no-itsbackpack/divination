class User < ActiveRecord::Base
  belongs_to :admin
  has_one :product
end

# a model that is a descendant of AR::Base but doesn't directly inherit AR::Base
class Admin < User
  has_one :user
end

# a class that uses abstract class
class Product < ActiveRecord::Base
  self.abstract_class = true
end
class Device < Product
end

#migrations
class CreateAllTables < ActiveRecord::Migration[5.0]
  def self.up
    create_table(:gem_defined_models) { |t| t.string :name; t.integer :age }
    create_table(:users) {|t| t.string :name; t.integer :age; t.integer :admin_id }
    create_table(:admin, primary_key: :admin_id) {|t| t.string :title}
    create_table(:devices) {|t| t.string :name; t.integer :age}
  end
end
ActiveRecord::Migration.verbose = false
CreateAllTables.up
