class ChangeTopicAccessDefault < ActiveRecord::Migration
  def up
    change_column_default(:topics, :access, 'public')
  end

  def down
    change_column_default(:topics, :access, nil)
  end
end
