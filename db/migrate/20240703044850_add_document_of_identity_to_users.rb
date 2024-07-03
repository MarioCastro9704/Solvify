class AddDocumentOfIdentityToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :document_of_identity, :string
  end
end
