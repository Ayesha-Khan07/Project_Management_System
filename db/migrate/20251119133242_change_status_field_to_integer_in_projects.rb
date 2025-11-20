class ChangeStatusFieldToIntegerInProjects < ActiveRecord::Migration[8.0]
  def up
    #Convert string values to integer values manually. becoz of this error: PG::DatatypeMismatch
                                # HINT: You might need to specify "USING status::integer".
    execute <<-SQL
      UPDATE projects
      SET status =
        CASE status
          WHEN 'pending' THEN 0
          WHEN 'working' THEN 1
          WHEN 'completed' THEN 2
          ELSE 0
        END;
    SQL

    #Change column type using SQL
    execute <<-SQL
      ALTER TABLE projects
      ALTER COLUMN status TYPE integer USING status::integer;
    SQL

    #Set default + NOT NULL
    change_column_default :projects, :status, 0
    change_column_null :projects, :status, false
  end

  def down
    # Reverse (optional)
    execute <<-SQL
      ALTER TABLE projects
      ALTER COLUMN status TYPE varchar USING
        CASE status
          WHEN 0 THEN 'pending'
          WHEN 1 THEN 'working'
          WHEN 2 THEN 'completed'
        END;
    SQL

    change_column_default :projects, :status, nil
  end
end
