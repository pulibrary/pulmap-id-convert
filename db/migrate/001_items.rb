Sequel.migration do
  up do
    create_table(:items) do
      String :ark, unique: true, null: false
      String :guid, unique: true, null: true
      Integer :image, unique: false, null: true
      index [:ark, :guid, :image]
    end
  end

  down do
    drop_table(:items, cascade: false)
  end
end
