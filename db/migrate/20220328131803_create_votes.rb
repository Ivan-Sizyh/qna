class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.belongs_to :author, null: false, foreign_key: { to_table: :users }
      t.belongs_to :votable, polymorphic: true
      t.integer :up

      t.timestamps
    end
  end
end
