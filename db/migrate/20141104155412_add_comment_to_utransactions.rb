class AddCommentToUtransactions < ActiveRecord::Migration
  def change
    add_column :utransactions, :comment, :string
  end
end
